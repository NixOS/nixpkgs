#!/usr/bin/env python3
"""
Regenerate thirdparty-sources.nix from a koreader source checkout.

koreader-base vendors dozens of thirdparty C/C++ libraries, each pinned by a
`external_project(DOWNLOAD URL <md5> <url>)` or
`external_project(DOWNLOAD GIT <rev> <remote>)` call in its own
base/thirdparty/<name>/CMakeLists.txt (or a `spec_rock(<url> <md5>)` call for
the base/thirdparty/spec/* lua test dependencies). This script walks those
files, re-fetches a correct hash for each pin, and writes out
thirdparty-sources.nix -- run by package.nix's `passthru.updateScript` after a
version bump, since koreader-base's own recipes can (and do) change which
deps exist, their versions, and their patches on every release.

This does NOT fully replace human review of a version bump: see the two
module-level dicts below, which encode judgment calls (which deps to skip,
which need a further patch in package.nix) that a new koreader-base release
could invalidate. Warnings are printed to stderr for anything this script
can't verify on its own.

Usage: update-thirdparty-sources.py <koreader-source-checkout> <thirdparty-sources.nix>
"""

import json
import re
import subprocess
import sys
import time
from pathlib import Path

# Deps koreader-base's own build vendors from source, but that package.nix
# instead takes from nixpkgs directly (see its `vendorStaticLib` /
# `vendorDataFile` / `vendorLuaFile` and the comments in this file for why).
SWAPPED_FOR_NIXPKGS = {
    "certifi": "vendored from nixpkgs' `cacert` instead; see package.nix.",
    "dkjson": "vendored from nixpkgs' `luajitPackages.dkjson` instead; see package.nix.",
    "sqlite": "vendored from nixpkgs' `sqlite` instead; see package.nix.",
    "utf8proc": "vendored from nixpkgs' `utf8proc` instead; see package.nix.",
    "xxhash": "vendored from nixpkgs' `xxhash` instead; see package.nix.",
    "zlib": "vendored from nixpkgs' `zlib` instead; see package.nix.",
}

# Deps whose base/cmake/CMakeLists.txt `declare_project()` call excludes them
# from the "all" build target on every platform Darwin could plausibly match
# (i.e. they're only built for real e-reader targets: CERVANTES/KINDLE/KOBO/
# POCKETBOOK/REMARKABLE/...), confirmed dead by actually removing each and
# doing a full build. Re-verify this (don't just trust the comment) if
# koreader-base's CMakeLists.txt restructures its DEPENDS graph, since
# EXCLUDE_FROM_ALL alone doesn't mean "never built" -- something else's
# DEPENDS could still pull a dep in transitively.
DEAD_ON_DARWIN = {
    "tar": 'excluded from the "all" target on Apple (base/cmake/CMakeLists.txt); never built on Darwin.',
    "openssh": 'excluded from the "all" target on Apple, same as "tar" above.',
    "dropbear": 'excluded from the "all" target except on CERVANTES/KINDLE/KOBO/POCKETBOOK, same as "openssh"/"tar" above; never built on Darwin.',
    "fbink": 'excluded from the "all" target except on KOBO/POCKETBOOK/REMARKABLE (same cluster as "fbdepth"/"libfbink_input", never separately vendored here); never built on Darwin.',
}

SKIP = {**SWAPPED_FOR_NIXPKGS, **DEAD_ON_DARWIN}

DOWNLOAD_RE = re.compile(
    r"DOWNLOAD\s+(URL|GIT)\s+(.*?)"
    r"(?=\n\s*(?:PATCH_|CMAKE_ARGS|CONFIGURE_COMMAND|BUILD_COMMAND|BUILD_DEPENDS|INSTALL_COMMAND|SOURCE_SUBDIR)|\s*\))",
    re.DOTALL,
)
SPEC_ROCK_RE = re.compile(r"spec_rock\(\s*(\S+)\s+([0-9a-f]{32})")


def sh(*args: str, attempts: int = 1) -> str:
    """Run a command and return its stdout, retrying transient failures."""
    for attempt in range(1, attempts + 1):
        try:
            return subprocess.run(
                args, check=True, capture_output=True, text=True
            ).stdout
        except subprocess.CalledProcessError:
            if attempt == attempts:
                raise
            time.sleep(2 * attempt)


def prefetch_url(url: str) -> str:
    out = sh(
        "nix",
        "store",
        "prefetch-file",
        "--hash-type",
        "sha256",
        "--json",
        url,
        attempts=3,
    )
    return json.loads(out)["hash"]


FULL_SHA_RE = re.compile(r"^[0-9a-f]{40}$")
DESCRIBE_RE = re.compile(r"-\d+-g([0-9a-f]{4,40})$")


def resolve_git_rev(url: str, rev: str) -> str:
    """Resolve a `DOWNLOAD GIT <rev>` value to a full commit SHA.

    Most of these are already a full SHA, which passes straight through. A
    few pin a `git describe --long`-style string (see gitrevisions(7):
    <describeOutput>) instead -- e.g. djvulibre's "release.3.5.30.1-2-g69e23da".
    Those don't exist as a real ref (`git ls-remote` won't find them), but
    `git rev-parse` resolves them from ANY clone that already has the
    trailing abbreviated commit reachable, by design (that's the whole point
    of feeding `git describe` output back into git). A full clone gives us
    that, letting us resolve it to a real commit SHA that fetchgit can pin.
    """
    if FULL_SHA_RE.match(rev):
        return rev
    # Ask for the peeled `<rev>^{}` form too: for an annotated tag, the plain
    # ref names the tag *object*, whereas the peeled one is the commit.
    ls_remote = sh("git", "ls-remote", url, rev, f"{rev}^{{}}")
    if ls_remote.strip():
        refs = [line.split() for line in ls_remote.strip().splitlines()]
        peeled = [sha for sha, ref in refs if ref.endswith("^{}")]
        return (peeled or [refs[0][0]])[0]
    if DESCRIBE_RE.search(rev):
        import tempfile

        with tempfile.TemporaryDirectory() as tmp:
            sh("git", "clone", "--quiet", url, tmp)
            return sh("git", "-C", tmp, "rev-parse", rev).strip()
    raise ValueError(
        f"couldn't resolve git rev {rev!r} for {url} as a full SHA, a remote "
        "ref, or git-describe output -- needs manual pinning"
    )


def prefetch_git(url: str, rev: str) -> tuple[str, str]:
    resolved = resolve_git_rev(url, rev)
    out = sh(
        "nix-prefetch-git",
        "--url",
        url,
        "--rev",
        resolved,
        "--fetch-submodules",
        "--quiet",
        attempts=3,
    )
    return resolved, json.loads(out)["hash"]


EXISTING_GIT_ENTRY_RE = re.compile(
    r'"([^"]+)"\s*=\s*fetchgit\s*\{\s*'
    r'url\s*=\s*"([^"]+)";\s*'
    r'rev\s*=\s*"([^"]+)";\s*'
    r'sha256\s*=\s*"([^"]+)";'
)


def load_existing_git_entries(path: Path) -> dict[str, tuple[str, str, str]]:
    """Fallback data source for git revs this run can't resolve on its own
    (see resolve_git_rev's ValueError case) -- keeps a manually-pinned rev
    from earlier intact, with a warning, rather than dropping the dependency
    or guessing.
    """
    if not path.exists():
        return {}
    text = path.read_text()
    return {
        name: (url, rev, sha256)
        for name, url, rev, sha256 in EXISTING_GIT_ENTRY_RE.findall(text)
    }


def parse_download(text: str):
    m = DOWNLOAD_RE.search(text)
    if not m:
        return None
    kind, rest = m.group(1), m.group(2).split()
    if kind == "URL":
        # rest = [md5, url, <fallback mirror urls...>] -- we only keep the
        # primary url, same as the hand-written file did before this script.
        return ("url", rest[1])
    else:
        # rest = [rev, remote, <submodule sparse-checkout paths...>] -- no
        # currently-vendored dep uses the sparse-checkout paths, so they're
        # not handled here; fetchSubmodules=true always fetches everything.
        return ("git", rest[0], rest[1])


def main() -> None:
    src_dir = Path(sys.argv[1])
    out_path = Path(sys.argv[2])
    thirdparty_dir = src_dir / "base" / "thirdparty"

    existing_git_entries = load_existing_git_entries(out_path)

    url_items: dict[str, tuple] = {}
    git_items: dict[str, tuple] = {}
    warnings: list[str] = []

    cmake_lists = sorted(thirdparty_dir.glob("*/CMakeLists.txt")) + sorted(
        (thirdparty_dir / "spec").glob("*/CMakeLists.txt")
    )
    for cml in cmake_lists:
        is_spec = cml.parent.parent.name == "spec"
        name = f"spec/{cml.parent.name}" if is_spec else cml.parent.name
        if name == "cmake_modules":
            continue
        if name in SKIP:
            url_items[name] = None  # placeholder: comment-only, see SKIP
            continue

        text = cml.read_text()
        if is_spec:
            m = SPEC_ROCK_RE.search(text)
            if not m:
                warnings.append(f"{name}: could not parse spec_rock() call")
                continue
            url = m.group(1)
            file = url.rsplit("/", 1)[-1]
            url_items[name] = (file, url, prefetch_url(url))
            continue

        parsed = parse_download(text)
        if parsed is None:
            continue  # no DOWNLOAD call: built from src_repo itself, not fetched separately
        if parsed[0] == "url":
            url = parsed[1]
            file = url.rsplit("/", 1)[-1]
            url_items[name] = (file, url, prefetch_url(url))
        else:
            _, rev, remote = parsed
            try:
                resolved, h = prefetch_git(remote, rev)
                git_items[name] = (remote, resolved, h)
            except (ValueError, subprocess.CalledProcessError) as e:
                if name in existing_git_entries:
                    git_items[name] = existing_git_entries[name]
                    warnings.append(
                        f"{name}: couldn't resolve new DOWNLOAD GIT ref {rev!r} ({e}) "
                        "-- kept the previous pin as-is, needs manual re-pinning"
                    )
                else:
                    warnings.append(
                        f"{name}: couldn't resolve DOWNLOAD GIT ref {rev!r} ({e}) "
                        "and there's no previous pin to fall back to -- dropped entirely, needs manual pinning"
                    )

    for name in SKIP:
        if name not in url_items and name not in git_items:
            warnings.append(
                f"{name}: was in the skip list but no longer exists in "
                "base/thirdparty/ at all -- remove it from this script"
            )

    lines = ["{ fetchurl, fetchgit }:", "{", "  url = {"]
    for name in sorted(url_items):
        entry = url_items[name]
        if entry is None:
            lines.append(f'    # "{name}" -> {SKIP[name]}')
            continue
        file, url, h = entry
        lines += [
            f'    "{name}" = {{',
            f'      file = "{file}";',
            "      src = fetchurl {",
            f'        url = "{url}";',
            f'        hash = "{h}";',
            "      };",
            "    };",
        ]
    lines += ["  };", "", "  git = {"]
    for name in sorted(git_items):
        remote, rev, h = git_items[name]
        lines += [
            f'    "{name}" = fetchgit {{',
            f'      url = "{remote}";',
            f'      rev = "{rev}";',
            f'      sha256 = "{h}";',
            "      fetchSubmodules = true;",
            "    };",
        ]
    lines += ["  };", "}", ""]

    out_path.write_text("\n".join(lines))

    if warnings:
        print("update-thirdparty-sources.py: needs manual review:", file=sys.stderr)
        for w in warnings:
            print(f"  - {w}", file=sys.stderr)


if __name__ == "__main__":
    main()
