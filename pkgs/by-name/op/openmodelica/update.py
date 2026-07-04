#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 git nix-prefetch-github
import argparse
import datetime as dt
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path


OWNER = "OpenModelica"
MAIN_REPO = "OpenModelica"
MSL_REPO = "OpenModelica-ModelicaStandardLibrary"
PACKAGE_NIX = Path(__file__).with_name("package.nix")


def run(command, *, cwd=None):
    try:
        result = subprocess.run(
            command,
            cwd=cwd,
            check=True,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    except subprocess.CalledProcessError as error:
        if error.stderr:
            print(error.stderr, file=sys.stderr, end="")
        raise
    return result.stdout


def prefetch_github(repo, rev, *, fetch_submodules=False):
    command = [
        "nix-prefetch-github",
        OWNER,
        repo,
        "--rev",
        rev,
        "--json",
    ]
    if fetch_submodules:
        command.append("--fetch-submodules")

    print(f"prefetching {OWNER}/{repo}@{rev}", file=sys.stderr)
    data = json.loads(run(command))
    hash_value = data.get("hash") or data.get("sha256")
    if not hash_value:
        raise RuntimeError(f"nix-prefetch-github did not return a hash for {repo}@{rev}")
    return {
        "rev": data.get("rev", rev),
        "hash": hash_value,
    }


def nix_string(value):
    return json.dumps(value)


def realise_fetch_from_github(repo, rev, hash_value, *, fetch_submodules=False):
    expr = """
let
  pkgs = import ./. {};
in
  pkgs.fetchFromGitHub {
    owner = %s;
    repo = %s;
    rev = %s;
    hash = %s;
    fetchSubmodules = %s;
  }
""" % (
        nix_string(OWNER),
        nix_string(repo),
        nix_string(rev),
        nix_string(hash_value),
        "true" if fetch_submodules else "false",
    )
    path = run(
        [
            "nix",
            "build",
            "--impure",
            "--no-link",
            "--print-out-paths",
            "--expr",
            expr,
        ],
        cwd=PACKAGE_NIX.parents[4],
    ).strip()
    if not path:
        raise RuntimeError(f"could not realise source for {OWNER}/{repo}@{rev}")
    return Path(path)


def resolve_rev(rev):
    if re.fullmatch(r"[0-9a-f]{40}", rev):
        return rev

    url = f"https://github.com/{OWNER}/{MAIN_REPO}.git"
    candidates = [
        rev,
        f"refs/heads/{rev}",
        f"refs/tags/{rev}^{{}}",
        f"refs/tags/{rev}",
    ]
    for candidate in candidates:
        output = run(["git", "ls-remote", url, candidate]).splitlines()
        if output:
            return output[0].split()[0]

    raise RuntimeError(f"could not resolve {rev!r} in {url}")


def library_attr_name(name, version, used_names):
    base_version = version.split("+", 1)[0]
    base = "v" + re.sub(r"[^A-Za-z0-9]+", "_", base_version).strip("_")
    if not re.match(r"^[A-Za-z_]", base):
        base = f"{name}_{base}"
    attr = base
    suffix = 2
    while attr in used_names:
        attr = f"{base}_{suffix}"
        suffix += 1
    used_names.add(attr)
    return attr


def read_standard_library_revisions(openmodelica_source):
    index_path = openmodelica_source / "libraries" / "install-index.json"
    with index_path.open(encoding="utf-8") as handle:
        index = json.load(handle)

    by_rev = {}
    for package_name, package in index["libs"].items():
        for version, metadata in package["versions"].items():
            by_rev.setdefault(metadata["sha"], []).append((package_name, version))

    used_names = set()
    revisions = []
    for rev, packages in by_rev.items():
        modelica_package = next(
            ((name, version) for name, version in packages if name == "Modelica"),
            packages[0],
        )
        name, version = modelica_package
        revisions.append(
            {
                "attr": library_attr_name(name, version, used_names),
                "rev": rev,
                "label": f"{name} {version}",
            }
        )

    return sorted(revisions, key=lambda item: item["attr"])


def format_library_sources(sources, base_indent="        "):
    lines = []
    for source in sources:
        lines.extend(
            [
                f"{base_indent}{source['attr']} = {{",
                f"{base_indent}  rev = {nix_string(source['rev'])};",
                f"{base_indent}  hash = {nix_string(source['hash'])};",
                f"{base_indent}}};",
            ]
        )
    return "\n".join(lines)


def collect_sources(main_rev):
    main = prefetch_github(MAIN_REPO, main_rev, fetch_submodules=True)
    source_path = realise_fetch_from_github(
        MAIN_REPO,
        main_rev,
        main["hash"],
        fetch_submodules=True,
    )
    library_revisions = read_standard_library_revisions(source_path)
    for source in library_revisions:
        prefetched = prefetch_github(MSL_REPO, source["rev"])
        source["hash"] = prefetched["hash"]
    return main, library_revisions


def replace_once(text, pattern, replacement):
    updated, count = re.subn(pattern, replacement, text, count=1, flags=re.S)
    if count != 1:
        raise RuntimeError(f"expected to replace exactly one match for {pattern!r}")
    return updated


def update_package(version, src_rev_expression, src_hash, library_sources):
    text = PACKAGE_NIX.read_text(encoding="utf-8")
    text = replace_once(text, r'version = "[^"]+";', f"version = {nix_string(version)};")
    text = replace_once(text, r'srcRev = "[^"]+";', f"srcRev = {src_rev_expression};")
    text = replace_once(text, r'srcHash = "[^"]+";', f"srcHash = {nix_string(src_hash)};")
    text = replace_once(
        text,
        r"(modelicaStandardLibrarySources = \{\n).*?(\n      \};)",
        r"\1" + format_library_sources(library_sources) + r"\2",
    )
    PACKAGE_NIX.write_text(text, encoding="utf-8")

    nixfmt = shutil.which("nixfmt")
    if nixfmt:
        run([nixfmt, str(PACKAGE_NIX)])


def print_override(version, src_rev, src_hash, library_sources):
    print("openmodelica.overrideAttrs (old: {")
    print(f"  version = {nix_string(version)};")
    print(f"  srcRev = {nix_string(src_rev)};")
    print(f"  srcHash = {nix_string(src_hash)};")
    print("  passthru = old.passthru // {")
    print("    modelicaStandardLibrarySources = {")
    print(format_library_sources(library_sources, base_indent="      "))
    print("    };")
    print("  };")
    print("})")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Update or override the nixpkgs OpenModelica package."
    )
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--version", help="OpenModelica release version, for example 1.28.0")
    source.add_argument("--rev", help="OpenModelica git revision, branch, tag, or HEAD")
    output = parser.add_mutually_exclusive_group(required=True)
    output.add_argument("--in-place", action="store_true", help="edit package.nix")
    output.add_argument(
        "--print-override",
        action="store_true",
        help="print an overrideAttrs snippet instead of editing package.nix",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    if args.in_place and args.rev:
        raise SystemExit("--in-place updates are only supported for release --version updates")

    if args.version:
        version = args.version
        src_rev = f"v{version}"
        prefetch_rev = src_rev
    else:
        version = f"unstable-{dt.date.today().isoformat()}"
        src_rev = resolve_rev(args.rev)
        prefetch_rev = src_rev

    main_source, library_sources = collect_sources(prefetch_rev)

    if args.in_place:
        update_package(version, '"v${finalAttrs.version}"', main_source["hash"], library_sources)
    else:
        print_override(version, src_rev, main_source["hash"], library_sources)


if __name__ == "__main__":
    main()
