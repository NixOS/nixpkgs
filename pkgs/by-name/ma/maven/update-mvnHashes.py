#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix-update
"""Update the mvnHash of every package built with maven.buildMavenPackage.

When the maven package is updated, its default plugin versions change. A
downstream package that does not pin all plugin versions in its pom.xml
then resolves different plugin versions, its dependency set changes, and
its mvnHash no longer matches. This script re-derives the hash for each
affected package.

How it works, per package (see resolve_attributes and update_package):

1. Find all .nix files under pkgs/ that call <builder>.buildMavenPackage
   and set a mvnHash, where <builder> defaults to "maven" and can be
   changed with --builder. This script itself contains no such call with
   an mvnHash line, so it is filtered out along with other non-package
   files.
2. Determine the attribute candidates: an entry from ATTRIBUTE_OVERRIDES
   if present, otherwise the pname, otherwise the directory name under
   pkgs/by-name/xx/name/. A single nix evaluation then resolves each
   package to the first candidate whose derivation exists and exposes
   the fetchedMavenDeps fixed-output derivation, which is what nix-update
   needs access to.
3. Run nix-update --version=skip --no-src for the attribute, pinned to
   the discovered file with --override-filename. nix-update re-derives
   the mvnHash by building fetchedMavenDeps with an empty outputHash and
   writes the resulting hash into the file; version and src hash stay
   untouched.

The whole cycle runs per package. An interrupted run leaves the packages
it finished updated and the rest untouched. For a package whose mvnHash
is already correct, nix-update leaves the file alone, so re-running is
safe.

Packages whose attribute could not be resolved or whose hash could not
be determined are listed at the end with their file path, so they can be
handled manually.

Pass one or more PACKAGE selectors to restrict the run to those packages.
A selector matches a package's pname, one of its nixpkgs attributes, its
directory name, or its file path (absolute, relative to the nixpkgs root,
or as a trailing fragment like `pdfsam-basic/package.nix`). A selector
that matches no package is an error, so typos do not silently skip
packages. Without selectors, every found package is processed.

Usage:
  ./update-mvnHashes.py [-j N] [--nixpkgs PATH] [--builder NAME]
                        [--commit [--assisted-by TEXT]] [PACKAGE ...]

With --commit, each updated package is committed on its own as
"<pname>: update mvnHash after maven package update". If the contribution
was produced with LLM assistance, pass --assisted-by with tool and model
name to add the trailer the nixpkgs automation/AI policy requires (see
CONTRIBUTING.md).

Needs network access for the maven downloads. Unfree packages are
handled by disabling nixpkgs' meta checks during evaluation, since only
the hash of their dependency derivation is needed.
"""

import argparse
import concurrent.futures
import json
import os
import re
import subprocess
import sys
import threading
from pathlib import Path

# manually curated overrides for packages whose pname is not a nixpkgs
# attribute: pname -> attribute path to build
ATTRIBUTE_OVERRIDES: dict[str, str] = {
    # helper derivation inside anyk, built as a dependency of anyk
    "anyk-soap-deps": "anyk",
    # only reachable through the ghidra-extensions scope; building it also
    # builds the binary-file-toolkit maven deps
    "binary-file-toolkit": "ghidra-extensions.ghidra-delinker-extension",
    # keycloak plugins, exposed via keycloak's `plugins` passthru
    "keycloak-discord": "keycloak.plugins.keycloak-discord",
    "keycloak-home-idp-discovery": "keycloak.plugins.keycloak-home-idp-discovery",
    "keycloak-magic-link": "keycloak.plugins.keycloak-magic-link",
    "keycloak-orgs": "keycloak.plugins.keycloak-orgs",
    "keycloak-remember-me-authenticator": "keycloak.plugins.keycloak-remember-me-authenticator",
    "keycloak-restrict-client-auth": "keycloak.plugins.keycloak-restrict-client-auth",
    "keycloak-secrets-vault-provider": "keycloak.plugins.keycloak-secrets-vault-provider",
    # attribute is all lowercase, pname is camelCase
    "tinyMediaManager": "tinymediamanager",
}

HASH_RE = re.compile(r'sha256-[A-Za-z0-9+/]+={0,2}')
MVNHASH_LINE_RE = re.compile(r'^(\s*mvnHash\s*=\s*")(' + HASH_RE.pattern + r')(".*$)', re.MULTILINE)
PNAME_RE = re.compile(r'pname\s*=\s*"([^"$\n{}]+)"')

# git operations from worker threads need to be serialized, git's index
# locking does not tolerate concurrent index.lock access
git_lock = threading.Lock()


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__,
        # keep the docstring's formatting (numbered list, paragraphs)
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--nixpkgs",
        type=Path,
        default=Path(__file__).resolve().parents[4],
        help="path to the nixpkgs checkout (default: auto-detected from this script's location)",
    )
    parser.add_argument(
        "--jobs",
        "-j",
        type=int,
        default=1,
        help="number of nix-update runs to execute in parallel",
    )
    parser.add_argument(
        "--builder",
        default="maven",
        help="name of the maven package whose buildMavenPackage callers to update, "
        "e.g. 'maven' (default) or 'maven_4'; its version bump is what invalidates "
        "the hashes",
    )
    parser.add_argument(
        "--commit",
        action="store_true",
        help="commit each updated package as '<pname>: update mvnHash after maven package update'",
    )
    parser.add_argument(
        "--assisted-by",
        default=None,
        help="value for an 'Assisted-by:' trailer in the commit messages, e.g. "
        "'OpenCode (GLM-5.3-Flash)'; required by the nixpkgs automation/AI policy "
        "when the commits were produced with LLM assistance (see CONTRIBUTING.md)",
    )
    parser.add_argument(
        "packages",
        nargs="*",
        metavar="PACKAGE",
        help="only update these packages; a selector matches a package's pname, "
        "one of its nixpkgs attributes, its directory name, or its file path "
        "(absolute, relative to --nixpkgs, or as a trailing fragment like "
        "'pdfsam-basic/package.nix')",
    )
    args = parser.parse_args()

    nixpkgs_root = args.nixpkgs.resolve()
    if not (nixpkgs_root / "pkgs").is_dir():
        parser.error(f"{nixpkgs_root} does not look like a nixpkgs checkout")

    if args.assisted_by and not args.commit:
        parser.error("--assisted-by requires --commit")

    # step 1: find all packages using <builder>.buildMavenPackage
    print(f"searching for packages using {args.builder}.buildMavenPackage...")
    maven_files = find_maven_files(nixpkgs_root, args.builder)
    print(f"found {len(maven_files)} files")

    # step 2: determine the attribute candidates for each file
    packages: dict[tuple[str, ...], tuple[str, Path]] = {}
    for path in maven_files:
        pname = extract_pname(path.read_text(), path, nixpkgs_root, args.builder)
        if pname is None:
            continue
        attributes = tuple(attribute_candidates(nixpkgs_root, path, pname))
        if attributes in packages:
            print(
                f"WARNING: duplicate attributes {attributes} ({packages[attributes][1]} and {path})",
                file=sys.stderr,
            )
        packages[attributes] = (pname, path)

    if args.packages:
        packages = select_packages(nixpkgs_root, packages, args.packages)

    # step 2b: resolve each package to an attribute nix-update can work with
    print("resolving attributes (checking that each exposes fetchedMavenDeps)...")
    resolved, unresolved = resolve_attributes(nixpkgs_root, packages)
    for attributes in unresolved:
        print(f"WARNING: {attributes[0]}: {unresolved[attributes]}", file=sys.stderr)

    print(f"updating {len(resolved)} of {len(packages)} packages, {args.jobs} at a time...")
    failures: dict[tuple[str, ...], str] = dict(unresolved)
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as executor:
        futures = {
            executor.submit(
                update_package,
                nixpkgs_root,
                packages[attributes][0],
                resolved[attributes],
                packages[attributes][1],
                args.commit,
                args.assisted_by,
            ): attributes
            for attributes in resolved
        }
        for future in concurrent.futures.as_completed(futures):
            attributes = futures[future]
            success, result = future.result()
            if success:
                print(f"{attributes[0]}: {result}")
            else:
                failures[attributes] = "nix-update failed (see its output above)"
                print(f"ERROR: could not determine new hash for {attributes[0]}:", file=sys.stderr)
                print(result, file=sys.stderr)

    if failures:
        print("\nfailed to update:", file=sys.stderr)
        for attributes in sorted(failures, key=lambda attributes: attributes[0]):
            print(
                f"  {attributes[0]} ({packages[attributes][1]}): {failures[attributes]}",
                file=sys.stderr,
            )
        sys.exit(1)


def find_maven_files(nixpkgs_root: Path, builder: str) -> list[Path]:
    """Step 1: find .nix files that use <builder>.buildMavenPackage.

    Matches `.buildMavenPackage` after `<builder>` or
    `<builder>.override { ... }`, but not through other maven versions'
    builders (maven_4 when updating maven, and vice versa), because their
    hashes are unaffected.
    """
    # the lookbehind keeps `maven` from matching inside `maven_4`, and the
    # optional `.override [..] )` covers callers like
    # `(maven.override { jdk_headless = jre; }).buildMavenPackage`
    call_re = re.compile(
        r"(?<![\w.])" + re.escape(builder) + r"(?:\.override\b[^)]*\))?\.buildMavenPackage"
    )
    matches = []
    for path in (nixpkgs_root / "pkgs").rglob("*.nix"):
        text = path.read_text()
        if not call_re.search(text):
            continue
        if not MVNHASH_LINE_RE.search(text):
            # files whose mvnHash is not a simple one-line string (per-system
            # attrsets, inline conditionals, let-bound values) cannot be
            # rewritten by this script; warn so they are not silently skipped
            print(
                f"WARNING: {path} uses {builder}.buildMavenPackage but its mvnHash "
                "is not a literal string; update it manually",
                file=sys.stderr,
            )
            continue
        matches.append(path)
    return sorted(set(matches))


def extract_pname(text: str, path: Path, nixpkgs_root: Path, builder: str) -> str | None:
    """Step 2: get the package name from its pname.

    Prefer a `pname` after the <builder>.buildMavenPackage call, so `pname`s
    of helper derivations in `let` blocks before it are not picked up instead.
    Fall back to the whole file (e.g. for `inherit pname`), and lastly to the
    directory name under pkgs/by-name/xx/name/.
    """
    match = PNAME_RE.search(text, pos=text.find(f"{builder}.buildMavenPackage"))
    if not match:
        match = PNAME_RE.search(text)
    if not match:
        path = path.resolve()
        by_name_dir = nixpkgs_root.resolve() / "pkgs" / "by-name"
        if by_name_dir in path.parents:
            match = PNAME_RE.match(r'[^"$\n{}]+', path.relative_to(by_name_dir).parts[1])
    if not match:
        print(f"WARNING: could not find pname in {path}", file=sys.stderr)
        return None
    return match.group(1)


def attribute_candidates(nixpkgs_root: Path, path: Path, pname: str) -> list[str]:
    """Step 2: compute the nixpkgs attribute candidates to try for a file.

    The pname often is not a top-level attribute, e.g. `commafeed` builds
    `commafeed-frontend`. For files under pkgs/by-name/xx/name/, the
    directory name is the attribute name, so try it after the pname.
    """
    if pname in ATTRIBUTE_OVERRIDES:
        return [ATTRIBUTE_OVERRIDES[pname], pname]
    path = path.resolve()
    by_name_dir = nixpkgs_root.resolve() / "pkgs" / "by-name"
    # the pname is the most specific candidate; try it first
    candidates = [pname]
    if by_name_dir in path.parents:
        # .../by-name/xx/name/*.nix -> attribute `name`, e.g. the pname
        # `commafeed-frontend` is built by the `commafeed` attribute
        directory_name = path.relative_to(by_name_dir).parts[1]
        if directory_name not in candidates:
            candidates.append(directory_name)
    return candidates


def resolve_attributes(
    nixpkgs_root: Path,
    packages: dict[tuple[str, ...], tuple[str, Path]],
) -> tuple[dict[tuple[str, ...], str], dict[tuple[str, ...], str]]:
    """Step 2: resolve each package to a single attribute for nix-update.

    Runs one nix evaluation that, for every package, picks the first
    attribute candidate whose derivation exists and exposes the
    fetchedMavenDeps fixed-output derivation - only those let nix-update
    reach the mvnHash. Returns (resolved, unresolved) maps keyed by the
    attribute candidates, to the resolved attribute / an explanation.
    """
    # also try each candidate's `.src` attribute: packages like
    # certificate-ripper build their maven jar as the src of a wrapper
    # (buildGraalvmNativeImage &c), so the top attribute itself does not
    # expose fetchedMavenDeps
    candidates = [
        {
            "key": index,
            "candidates": list(attributes) + [f"{attr}.src" for attr in attributes],
        }
        for index, attributes in enumerate(packages)
    ]
    proc = subprocess.run(
        [
            "nix-instantiate",
            "--eval",
            "--json",
            "--strict",
            "--expr",
            f'''
            {{ candidatesJson }}:
            let
              pkgs = import {nixpkgs_root} {{ config.checkMeta = false; overlays = []; }};
              lib = pkgs.lib;
              usable = cand:
                let
                  r = builtins.tryEval (
                    let v = lib.attrByPath (lib.splitString "." cand) null pkgs;
                    in v != null && v ? fetchedMavenDeps
                  );
                in
                if r.success && r.value then cand else null;
            in
            map (pkg: map usable pkg.candidates) (builtins.fromJSON candidatesJson)
            ''',
            "--argstr",
            "candidatesJson",
            json.dumps(candidates),
        ],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        print("ERROR: nix evaluation for attribute resolution failed:", file=sys.stderr)
        print(proc.stdout + proc.stderr, file=sys.stderr)
        sys.exit(1)

    resolved: dict[tuple[str, ...], str] = {}
    unresolved: dict[tuple[str, ...], str] = {}
    for attributes, candidates_result in zip(packages, json.loads(proc.stdout)):
        attribute = next((c for c in candidates_result if c is not None), None)
        if attribute is not None:
            resolved[attributes] = attribute
        else:
            unresolved[attributes] = (
                f"none of the candidates {' '.join(attributes)} exists in nixpkgs "
                "or exposes fetchedMavenDeps (is the mvnHash on a helper derivation "
                "that the attribute does not expose via passthru?)"
            )
    return resolved, unresolved


def select_packages(
    nixpkgs_root: Path,
    packages: dict[tuple[str, ...], tuple[str, Path]],
    selectors: list[str],
) -> dict[tuple[str, ...], tuple[str, Path]]:
    """Restrict the discovered packages to those matching any selector.

    A selector matches a package's pname, one of its attribute candidates,
    its directory name, or its file path (absolute, relative to the nixpkgs
    root, or as a trailing fragment like 'pdfsam-basic/package.nix').
    Selectors that match nothing are an error, so a typo does not silently
    skip a package.
    """

    def matches(selector: str, pname: str, attributes: tuple[str, ...], path: Path) -> bool:
        path = path.resolve()
        if selector in (pname, *attributes, path.parent.name):
            return True
        selector_path = Path(selector)
        if selector_path.is_absolute():
            return path == selector_path.resolve()
        if not path.is_relative_to(nixpkgs_root):
            return False
        parts = selector_path.parts
        relative_parts = path.relative_to(nixpkgs_root).parts
        return parts == relative_parts[-len(parts):]

    filtered = {
        attributes: entry
        for attributes, entry in packages.items()
        if any(matches(selector, entry[0], attributes, entry[1]) for selector in selectors)
    }
    unmatched = [
        selector
        for selector in selectors
        if not any(
            matches(selector, entry[0], attributes, entry[1])
            for attributes, entry in packages.items()
        )
    ]
    if unmatched:
        print(f"error: no package matches: {', '.join(unmatched)}", file=sys.stderr)
        sys.exit(1)
    return filtered


def update_package(
    nixpkgs_root: Path,
    pname: str,
    attribute: str,
    path: Path,
    commit: bool,
    assisted_by: str | None,
) -> tuple[bool, str]:
    """Run the full update cycle (step 3) for a single package.

    Doing the whole pass per package (instead of running everything up front)
    means an interrupted run leaves finished packages updated and the rest
    untouched.
    """
    before = path.read_bytes()
    success, output = nix_update(nixpkgs_root, attribute, path.relative_to(nixpkgs_root))
    if not success:
        return False, output
    if path.read_bytes() != before:
        if commit:
            commit_package(nixpkgs_root, pname, path, assisted_by)
        return True, f"new hash {read_mvn_hashes(path)}"
    return True, "mvnHash already up to date"


def nix_update(nixpkgs_root: Path, attribute: str, rel_path: Path) -> tuple[bool, str]:
    """Step 3: run nix-update to re-derive and write the mvnHash.

    --version=skip leaves the version alone, --no-src skips the (unchanged)
    src hash, and --override-filename pins the edit to the discovered file.
    """
    result = subprocess.run(
        [
            "nix-update",
            "--version=skip",
            "--no-src",
            "--override-filename",
            str(rel_path),
            attribute,
        ],
        cwd=nixpkgs_root,
        capture_output=True,
        text=True,
        # some maven packages like tinyMediaManager are unfree; since we
        # only need the hash mismatch from their dependency derivation,
        # allow them
        env={**os.environ, "NIXPKGS_ALLOW_UNFREE": "1"},
    )
    return result.returncode == 0, result.stdout + result.stderr


def read_mvn_hashes(path: Path) -> str:
    """All mvnHash values currently set in the file, for reporting."""
    hashes = [
        m.group(2)
        for line in path.read_text().splitlines()
        if (m := MVNHASH_LINE_RE.match(line))
    ]
    return ", ".join(hashes)


def commit_package(
    nixpkgs_root: Path,
    pname: str,
    path: Path,
    assisted_by: str | None,
) -> None:
    """After step 3: commit the updated mvnHash with a message matching nixpkgs conventions."""
    with git_lock:
        rel_path = path.relative_to(nixpkgs_root)
        subprocess.run(["git", "-C", str(nixpkgs_root), "add", str(rel_path)], check=True)
        subject = f"{pname}: update mvnHash after maven package update"
        body = []
        if assisted_by:
            body.append(f"Assisted-by: {assisted_by}")
        args = ["git", "-C", str(nixpkgs_root), "commit", "-m", subject]
        for part in body:
            args += ["-m", part]
        subprocess.run(args, check=True)


if __name__ == "__main__":
    main()
