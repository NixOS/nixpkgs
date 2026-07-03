#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (p: [ p.waybackpy p.requests ])"

from pathlib import Path
import json
import subprocess

import requests
import waybackpy

# Upstream doesn't provide persistent versioned URLs so we put the download link in Wayback Machine to preserve it.

user_agent = "nixpkgs-update-capacities/1 https://github.com/NixOS/nixpkgs"

session = requests.Session()
session.headers["User-Agent"] = user_agent

response = session.get("https://repology.org/api/v1/project/capacities").json()
latest_version = max(item["version"] for item in response)

# the wayback machine may take some time to respond to our save request, so we fetch upstream's version here instead of trying to fetch directly from wayback machine.
print("Prefetching...")
upstream_url = f"https://2vks4.upcloudobjects.com/capacities-desktop-app/Capacities-{latest_version}.AppImage"
sha256, unpack_path = subprocess.check_output(["nix-prefetch-url", "--print-path", upstream_url], universal_newlines=True).split("\n")[:2]

print(f"Archiving version {latest_version}...")
save_api = waybackpy.WaybackMachineSaveAPI(upstream_url, user_agent)
saved_url = save_api.save()

print("Writing version.json...")
(Path(__file__).parent / "version.json").write_text(json.dumps({
  "url": saved_url,
  "sha256": sha256,
  "version": latest_version,
}, indent=2) + "\n")
