"""Regenerate pkgs/by-name/le/lean4/cmake-content.json from lean4.src."""
from __future__ import annotations

import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

PACKAGE_REL = Path("pkgs/by-name/le/lean4")


def run(cmd: list[str], **kw) -> subprocess.CompletedProcess:
    print("+", " ".join(cmd), flush=True)
    return subprocess.run(cmd, check=True, text=True, **kw)


def find_nixpkgs_root() -> Path:
    start = Path.cwd().resolve()
    for p in [start, *start.parents]:
        if (p / "default.nix").exists() and (p / "pkgs").is_dir():
            return p
    raise SystemExit("could not find nixpkgs root (run from a nixpkgs checkout)")


def package_dir(root: Path) -> Path:
    return root / PACKAGE_REL


def nix_build_src(root: Path) -> Path:
    attr = os.environ.get("UPDATE_NIX_ATTR_PATH", "lean4")
    src_attr = attr if attr.endswith(".src") else f"{attr}.src"
    out = run(
        ["nix-build", str(root), "-A", src_attr, "--no-out-link"],
        capture_output=True,
        cwd=str(root),
    ).stdout.strip()
    p = Path(out)
    assert p.is_dir(), (out, p)
    return p


def parse_github(url: str) -> tuple[str, str] | None:
    m = re.match(
        r"https?://github\.com/([^/]+)/([^/]+?)(?:\.git)?/?$",
        url.strip(),
    )
    if not m:
        return None
    return m.group(1), m.group(2)


def entries_from_externalproject(src: Path) -> dict[str, dict]:
    """Top-level ExternalProject_Add git pins only."""
    out: dict[str, dict] = {}
    top = src / "CMakeLists.txt"
    if not top.is_file():
        return out
    text = top.read_text(errors="replace")
    for m in re.finditer(
        r"ExternalProject_Add\s*\(\s*([A-Za-z0-9_.-]+)\b(.*?)\n\s*\)",
        text,
        flags=re.S | re.I,
    ):
        name, body = m.group(1), m.group(2)
        rm = re.search(r"GIT_REPOSITORY\s+(\S+)", body)
        tm = re.search(r"GIT_TAG\s+(\S+)", body)
        if not rm or not tm:
            continue
        gh = parse_github(rm.group(1))
        if not gh:
            continue
        owner, repo_name = gh
        out[name] = {
            "method": "github",
            "owner": owner,
            "repo": repo_name,
            "tag": tm.group(1),
        }
        print(f"EP: {name} -> {owner}/{repo_name} {tm.group(1)}", flush=True)
    return out


def entries_from_provider_jsonl(path: Path) -> dict[str, dict]:
    out: dict[str, dict] = {}
    if not path.is_file() or path.stat().st_size == 0:
        return out
    for line in path.read_text().splitlines():
        if not line.strip():
            continue
        obj = json.loads(line)
        name = obj.get("name")
        if not name:
            continue
        upper = {k.upper(): v for k, v in obj.items() if k != "name"}
        repo, tag = upper.get("GIT_REPOSITORY"), upper.get("GIT_TAG")
        if repo and tag:
            gh = parse_github(repo)
            if not gh:
                continue
            owner, repo_name = gh
            out[name] = {
                "method": "github",
                "owner": owner,
                "repo": repo_name,
                "tag": str(tag).removeprefix("refs/tags/"),
            }
            continue
        url = upper.get("URL")
        if url:
            out[name] = {
                "method": "url",
                "url": url,
                "url_hash": upper.get("URL_HASH") or "",
            }
    return out


def try_cmake_provider(src: Path, build: Path, provider: Path) -> dict[str, dict]:
    build.mkdir(parents=True, exist_ok=True)
    cmake = shutil.which("cmake")
    if not cmake:
        print("cmake not on PATH; skipping FetchContent provider", file=sys.stderr)
        return {}

    cmd = [
        cmake,
        "-S",
        str(src),
        "-B",
        str(build),
        "-G",
        "Unix Makefiles",
        f"-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES={provider}",
        "-DUSE_GITHASH=OFF",
        "-DINSTALL_LICENSE=OFF",
        "-DINSTALL_CADICAL=OFF",
        "-DUSE_MIMALLOC=ON",
        "-DCMAKE_BUILD_TYPE=Release",
    ]
    proc = subprocess.run(cmd, check=False, text=True)
    lock = build / "fetchcontent-lock.jsonl"
    if not lock.is_file():
        print(
            f"no FetchContent lock at {lock} (cmake exit {proc.returncode})",
            file=sys.stderr,
        )
        return {}
    entries = entries_from_provider_jsonl(lock)
    for name, spec in entries.items():
        print(
            f"FC: {name} -> {spec.get('owner')}/{spec.get('repo')} {spec.get('tag')}",
            flush=True,
        )
    return entries


def prefetch_github(owner: str, repo: str, tag: str) -> str:
    cmd = ["nix-prefetch-github", owner, repo, "--rev", tag]
    print("+", " ".join(cmd), flush=True)
    proc = subprocess.run(cmd, check=False, text=True, capture_output=True)
    if proc.returncode != 0:
        raise SystemExit(
            f"nix-prefetch-github {owner}/{repo} {tag} failed "
            f"(exit {proc.returncode}):\n{proc.stderr or proc.stdout}"
        )
    data = json.loads(proc.stdout)
    h = data.get("hash") or data.get("sha256")
    if not h:
        raise SystemExit(f"missing hash from nix-prefetch-github: {data}")
    return h


def main() -> None:
    root = find_nixpkgs_root()
    os.chdir(root)
    # Host channels may be missing; point <nixpkgs> at this checkout for prefetch.
    os.environ["NIX_PATH"] = f"nixpkgs={root}"

    pkg = package_dir(root)
    lock_path = pkg / "cmake-content.json"
    provider = pkg / "nix-fetchcontent-lock.cmake"
    if not provider.is_file():
        raise SystemExit(f"missing {provider}")

    src = nix_build_src(root)
    print(f"src = {src}", flush=True)

    entries = entries_from_externalproject(src)
    with tempfile.TemporaryDirectory(prefix="lean4-fc-lock-") as td:
        fc = try_cmake_provider(src, Path(td) / "build", provider)
    entries.update(fc)

    if not entries:
        raise SystemExit("no cmake content dependencies discovered")

    lock_out: dict[str, dict] = {}
    for name, spec in sorted(entries.items()):
        if spec.get("method") != "github":
            print(f"skip non-github {name}: {spec}", file=sys.stderr)
            continue
        owner, repo, tag = spec["owner"], spec["repo"], spec["tag"]
        print(f"prefetch {name}: {owner}/{repo} {tag}", flush=True)
        h = prefetch_github(owner, repo, tag)
        lock_out[name] = {
            "owner": owner,
            "repo": repo,
            "tag": tag,
            "hash": h if h.startswith("sha256-") else f"sha256-{h}",
        }

    if not lock_out:
        raise SystemExit("no github dependencies to lock")

    lock_path.write_text(json.dumps(lock_out, indent=2) + "\n")
    print(f"wrote {lock_path}", flush=True)


if __name__ == "__main__":
    main()
