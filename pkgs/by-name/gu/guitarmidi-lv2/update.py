#!/usr/bin/env python3
import json
import os
import re
import subprocess
import urllib.request

OWNER = "geraldmwangi"
REPO = "GuitarMidi-LV2"
PNAME = "guitarmidi-lv2"
PACKAGE_FILE = "pkgs/by-name/gu/guitarmidi-lv2/package.nix"


def fetch_json(url):
    req = urllib.request.Request(
        url, headers={"User-Agent": "Nixpkgs-Updater-GuitarMidi-LV2"}
    )
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode("utf-8"))


def fetch_raw(url):
    req = urllib.request.Request(
        url, headers={"User-Agent": "Nixpkgs-Updater-GuitarMidi-LV2"}
    )
    with urllib.request.urlopen(req) as response:
        return response.read().decode("utf-8")


def prefetch_hash(url):
    cmd = ["nix", "store", "prefetch-file", "--json", "--unpack", url]
    res = subprocess.run(cmd, capture_output=True, text=True, check=True)
    out = json.loads(res.stdout)
    return out["hash"]


def main():
    print("Fetching latest release from GitHub...")
    latest_release = fetch_json(
        f"https://api.github.com/repos/{OWNER}/{REPO}/releases/latest"
    )
    latest_version = latest_release["tag_name"].lstrip("v")

    with open(PACKAGE_FILE, "r") as f:
        content = f.read()

    current_version = re.search(r'version = "([^"]+)";', content).group(1)

    if current_version == latest_version:
        print(f"guitarmidi-lv2 is up-to-date: {current_version}")
        return

    print(f"Updating guitarmidi-lv2 from {current_version} to {latest_version}...")

    # Update main version and source hash
    main_url = f"https://github.com/{OWNER}/{REPO}/archive/v{latest_version}.tar.gz"
    main_hash = prefetch_hash(main_url)

    content = re.sub(r'version = "[^"]+";', f'version = "{latest_version}";', content)
    # Find the src fetchFromGitHub hash and update it
    # We want to replace the first hash after the pname/version
    src_match = re.search(
        r"src = fetchFromGitHub \{[^}]+hash = \"([^\"]+)\";", content
    )
    if src_match:
        content = content.replace(src_match.group(1), main_hash, 1)

    # Fetch submodule commit of ext/tensorflow
    print("Fetching ext/tensorflow submodule commit...")
    ext_contents = fetch_json(
        f"https://api.github.com/repos/{OWNER}/{REPO}/contents/ext?ref=v{latest_version}"
    )
    tf_commit = None
    for item in ext_contents:
        if item["name"] == "tensorflow":
            tf_commit = item["sha"]
            break

    if not tf_commit:
        raise Exception("Could not find ext/tensorflow submodule in repository contents!")

    print(f"TensorFlow submodule commit: {tf_commit}")

    # Fetch new TensorFlow source hash
    tf_url = f"https://github.com/tensorflow/tensorflow/archive/{tf_commit}.tar.gz"
    tf_hash = prefetch_hash(tf_url)

    tf_block = re.search(
        r"tensorflow-src = fetchFromGitHub \{[^}]+rev = \"([^\"]+)\";[^}]+hash = \"([^\"]+)\";",
        content,
    )
    if tf_block:
        content = content.replace(tf_block.group(1), tf_commit, 1)
        content = content.replace(tf_block.group(2), tf_hash, 1)

    # Fetch and parse the CMake modules for each dependency
    deps = {
        "abseil-cpp": {
            "cmake_file": "abseil-cpp.cmake",
            "owner": "abseil",
            "repo": "abseil-cpp",
        },
        "eigen": {
            "cmake_file": "eigen.cmake",
            "owner": "libeigen",
            "repo": "eigen",
            "is_gitlab": True,
        },
        "gemmlowp": {
            "cmake_file": "gemmlowp.cmake",
            "owner": "google",
            "repo": "gemmlowp",
        },
        "ruy": {"cmake_file": "ruy.cmake", "owner": "google", "repo": "ruy"},
        "cpuinfo": {
            "cmake_file": "cpuinfo.cmake",
            "owner": "pytorch",
            "repo": "cpuinfo",
        },
        "xnnpack": {
            "cmake_file": "xnnpack.cmake",
            "owner": "google",
            "repo": "XNNPACK",
        },
        "farmhash": {
            "cmake_file": "farmhash.cmake",
            "owner": "google",
            "repo": "farmhash",
        },
        "ml_dtypes": {
            "cmake_file": "ml_dtypes.cmake",
            "owner": "jax-ml",
            "repo": "ml_dtypes",
        },
    }

    for dep_name, info in deps.items():
        print(f"Parsing CMake module for {dep_name}...")
        cmake_url = f"https://raw.githubusercontent.com/tensorflow/tensorflow/{tf_commit}/tensorflow/lite/tools/cmake/modules/{info['cmake_file']}"
        cmake_src = fetch_raw(cmake_url)

        dep_commit = re.search(r"GIT_TAG\s+([a-f0-9]{40})", cmake_src)
        if not dep_commit:
            # Fallback to tag/version format if not 40-char SHA
            dep_commit = re.search(r"GIT_TAG\s+(\S+)", cmake_src)

        if not dep_commit:
            raise Exception(f"Could not find GIT_TAG inside {info['cmake_file']}!")

        commit_sha = dep_commit.group(1)
        print(f"  Commit: {commit_sha}")

        # Compute SRI hash
        if info.get("is_gitlab"):
            dep_url = f"https://gitlab.com/api/v4/projects/{info['owner']}%2F{info['repo']}/repository/archive.tar.gz?sha={commit_sha}"
        else:
            dep_url = (
                f"https://github.com/{info['owner']}/{info['repo']}/archive/{commit_sha}.tar.gz"
            )

        print(f"  Prefetching hash for {dep_name}...")
        dep_hash = prefetch_hash(dep_url)
        print(f"  Hash: {dep_hash}")

        # Update commit and hash in package.nix
        dep_block = re.search(
            dep_name
            + r"-src = fetchFromGit(Hub|Lab) \{[^}]+rev = \"([^\"]+)\";[^}]+hash = \"([^\"]+)\";",
            content,
        )
        if dep_block:
            content = content.replace(dep_block.group(2), commit_sha, 1)
            content = content.replace(dep_block.group(3), dep_hash, 1)

    # Fetch and update subdirectories under ext/ for: kleidiai, pthreadpool, fp16, fxdiv, fft2d
    exts = ["kleidiai", "pthreadpool", "fp16", "fxdiv", "fft2d"]
    for ext_name in exts:
        print(f"Fetching subdirectories for ext/{ext_name}...")
        subdirs = fetch_json(
            f"https://api.github.com/repos/{OWNER}/{REPO}/contents/ext/{ext_name}?ref=v{latest_version}"
        )
        dir_name = None
        for item in subdirs:
            if item["type"] == "dir":
                dir_name = item["name"]
                break

        if not dir_name:
            # Fallback if no directory found (e.g. flatbuffers subdirectory structure is flat/direct)
            continue

        print(f"  Found directory: {dir_name}")

        # Update CMake flags and path names in package.nix
        # Replace occurrences like: /build/source/ext/kleidiai/kleidiai-xxxx
        content = re.sub(
            rf"/build/source/ext/{ext_name}/[a-zA-Z0-9_\.-]+",
            f"/build/source/ext/{ext_name}/{dir_name}",
            content,
        )

    # Write changes back
    with open(PACKAGE_FILE, "w") as f:
        f.write(content)

    print("Formatting package.nix with nixfmt...")
    subprocess.run(["nixfmt", PACKAGE_FILE], check=True)

    print("Successfully updated package.nix and all pinned dependencies!")


if __name__ == "__main__":
    main()
