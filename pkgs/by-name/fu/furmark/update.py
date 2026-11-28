#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3
# i686-linux stays at 2.0.16: upstream no longer ships 32-bit Linux builds.
import json, os, re, subprocess, sys, tempfile, urllib.request
from pathlib import Path

root = subprocess.check_output(
    ["git", "rev-parse", "--show-toplevel"], text=True
).strip()
path = Path(root, "pkgs/by-name/fu/furmark/package.nix")
old = text = path.read_text()
get = lambda url: urllib.request.urlopen(url, timeout=30)
parse = lambda version: tuple(map(int, version.split(".")))
page = get("https://www.geeks3d.com/furmark/downloads/").read().decode()

for system, arch in {"x86_64-linux": "linux64", "aarch64-linux": "arm64"}.items():
    show_id, new = re.search(rf'/dl/show/(\d+)"[^>]*>v([\d.]+) - {arch}', page).groups()
    current = re.search(rf'"{system}" = "([\d.]+)";', text)[1]
    if parse(new) <= parse(current):
        print(f"{system}: {current} is up to date (upstream: {new})")
        continue
    url = get(f"https://www.geeks3d.com/dl/get/{show_id}").geturl()
    if not url.startswith("https://gpumagick.com/"):
        sys.exit(f"error: unexpected URL: {url}")
    prefetch = [
        "nix",
        "--extra-experimental-features",
        "nix-command",
        "store",
        "prefetch-file",
        "--json",
        url,
    ]
    hash = json.loads(subprocess.check_output(prefetch))["hash"]
    text = text.replace(f'"{system}" = "{current}";', f'"{system}" = "{new}";', 1)
    pattern = rf'("{system}" = \{{.*?url = ")[^"]*(";\s*hash = ")[^"]*'
    text, count = re.subn(pattern, rf"\g<1>{url}\g<2>{hash}", text, count=1, flags=re.S)
    if count != 1:
        sys.exit(f"error: no sources for {system}")
    print(f"{system}: {current} -> {new}")

if text != old:
    with tempfile.NamedTemporaryFile("w", dir=path.parent, delete=False) as tmp:
        tmp.write(text)
    os.chmod(tmp.name, path.stat().st_mode)
    os.replace(tmp.name, path)
