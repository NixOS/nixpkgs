#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3
"""Update the mvnHash of every package built with maven.buildMavenPackage.

When the maven package is updated, its default plugin versions change. A
downstream package that does not pin all plugin versions in its pom.xml
then resolves different plugin versions, its dependency set changes, and
its mvnHash no longer matches. This script re-derives the hash for each
affected package.

How it works, per package (see update_package):

1. Find all .nix files under pkgs/ that call <builder>.buildMavenPackage
   and set a mvnHash, where <builder> defaults to "maven" and can be
   changed with --builder. This script itself contains no such call with
   an mvnHash line, so it is filtered out along with other non-package
   files.
2. Determine the attribute to build: an entry from ATTRIBUTE_OVERRIDES if
   present, otherwise the pname, otherwise the directory name under
   pkgs/by-name/xx/name/.
3. Replace the mvnHash line with a fake hash, so the dependency
   derivation actually builds and fails.
4. Run nix-build -A attribute and parse the "specified:" / "got:" lines
   from the hash mismatch error to learn the new hash.
5. Write the new hash into the file.

The whole cycle runs per package. An interrupted run leaves the packages
it finished updated and the rest untouched. For a package whose mvnHash
is already correct, the "got" hash equals the "specified" hash and the
file is left alone, so re-running is safe.

Packages whose hash could not be determined are listed at the end with
their file path, so they can be handled manually.

Usage:
  ./update-mvnHashes.py [-j N] [--nixpkgs PATH] [--builder NAME]
                        [--commit [--assisted-by TEXT]]

With --commit, each updated package is committed on its own as
"<pname>: update mvnHash after maven package update". If the contribution
was produced with LLM assistance, pass --assisted-by with tool and model
name to add the trailer the nixpkgs automation/AI policy requires (see
CONTRIBUTING.md).

Needs network access for the maven downloads. Unfree packages are
allowed, since only the hash mismatch from their dependency derivation
is needed.
"""

import argparse
import concurrent.futures
import os
import re
import subprocess
import sys
import threading
from pathlib import Path

# must match the length of a real sha256 base64 hash, otherwise the fixed-output
# derivation would be rejected before even building
FAKE_HASH = "sha256-" + "A" * 43 + "="

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

# matches lines from nix output like:
#   specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
#   got:       sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
SPECIFIED_RE = re.compile(r'(?i)specified\s*:\s*(' + HASH_RE.pattern + r')')
GOT_RE = re.compile(r'(?i)\bgot\s*:\s*(' + HASH_RE.pattern + r')')

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
        help="number of nix-build evaluations to run in parallel",
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

    # step 2: determine the attribute to build for each file
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

    print(f"updating {len(packages)} packages, {args.jobs} at a time...")
    failures: dict[tuple[str, ...], str] = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as executor:
        futures = {
            executor.submit(
                update_package,
                nixpkgs_root,
                pname,
                list(attributes),
                path,
                args.commit,
                args.assisted_by,
            ): attributes
            for attributes, (pname, path) in packages.items()
        }
        for future in concurrent.futures.as_completed(futures):
            attributes = futures[future]
            success, result = future.result()
            if success:
                print(f"{attributes[0]}: new hash {result}")
            else:
                failures[attributes] = result
                print(f"ERROR: could not determine new hash for {attributes[0]}:", file=sys.stderr)
                print(result, file=sys.stderr)

    if failures:
        print("\nfailed to update:", file=sys.stderr)
        for attributes in sorted(failures, key=lambda attributes: attributes[0]):
            print(
                f"  {attributes[0]} ({packages[attributes][1]}): tried attributes: {' '.join(attributes)}",
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


def update_package(
    nixpkgs_root: Path,
    pname: str,
    attributes: list[str],
    path: Path,
    commit: bool,
    assisted_by: str | None,
) -> tuple[bool, str]:
    """Run the full update cycle (steps 3 to 5) for a single package.

    Doing the whole pass per package (instead of faking everything up front)
    means an interrupted run leaves finished packages updated and the rest
    untouched.
    """
    fake_hash(path)
    success, result, not_found = build_package(nixpkgs_root, attributes)
    if not success:
        return False, result
    changed = replace_hashes(path, result)
    if changed and commit:
        commit_package(nixpkgs_root, pname, path, result, assisted_by)
    return True, result


def fake_hash(path: Path) -> None:
    """Step 3: replace the mvnHash in the file with a fake hash."""
    lines = path.read_text().splitlines(keepends=True)
    new_lines = []
    for line in lines:
        m = MVNHASH_LINE_RE.match(line)
        if m:
            line = m.group(1) + FAKE_HASH + m.group(3) + ("\n" if line.endswith("\n") else "")
        new_lines.append(line)
    path.write_text("".join(new_lines))


def build_package(nixpkgs_root: Path, attributes: list[str]) -> tuple[bool, str, list[str]]:
    """Step 4: run nix-build and capture the log output.

    Tries each attribute candidate in order; returns (success, result,
    attributes that could not be found).
    """
    not_found = []
    for attribute in attributes:
        print(f"building {attribute}...")
        result = subprocess.run(
            ["nix-build", str(nixpkgs_root), "-A", attribute, "--no-out-link"],
            capture_output=True,
            text=True,
            # some maven packages like tinyMediaManager are unfree; since we
            # only need the hash mismatch from the deps FOD, allow them
            env={**os.environ, "NIXPKGS_ALLOW_UNFREE": "1"},
        )
        # nix-build fails on a hash mismatch, which is exactly what we expect here
        output = result.stdout + result.stderr
        specified = SPECIFIED_RE.search(output)
        got = GOT_RE.search(output)
        if got:
            # if the specified hash equals the got hash, the package did not change
            if specified and specified.group(1) == got.group(1):
                return False, output, not_found
            return True, got.group(1), not_found
        if "not found" in output:
            not_found.append(attribute)
            continue
        return False, output, not_found
    return False, f"none of the attributes {' '.join(attributes)} exist in nixpkgs", not_found


def replace_hashes(path: Path, new_hash: str) -> bool:
    """Step 5: replace the (fake) mvnHash in the file with the new hash."""
    lines = path.read_text().splitlines(keepends=True)
    changed = False
    for i, line in enumerate(lines):
        m = MVNHASH_LINE_RE.match(line)
        if m and m.group(2) != new_hash:
            lines[i] = m.group(1) + new_hash + m.group(3) + ("\n" if line.endswith("\n") else "")
            changed = True
    if changed:
        path.write_text("".join(lines))
    return changed


def commit_package(
    nixpkgs_root: Path,
    pname: str,
    path: Path,
    new_hash: str,
    assisted_by: str | None,
) -> None:
    """After step 5: commit the updated mvnHash with a message matching nixpkgs conventions."""
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
