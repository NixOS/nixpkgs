#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (p: [p.waybackpy])"
import subprocess
from pathlib import Path
import re
import json
import waybackpy
import urllib.request
import tempfile
import zipfile

def check_version(base_path):
  manifest = (base_path / "META-INF" / "MANIFEST.MF").read_text()

  return re.search("Implementation-Version: (.+)", manifest).group(1)

nav_url = "https://nav.gov.hu/pfile/programFile?path=/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava"

version_path = Path("pkgs/by-name/an/anyk/version.json")

current_version = json.loads(version_path.read_text())["version"]

print("Checking latest version...")
# First, check the version of the latest JAR.
with tempfile.NamedTemporaryFile() as tmp_jar:
  urllib.request.urlretrieve(nav_url, tmp_jar.name)

  with zipfile.ZipFile(tmp_jar) as zip:
    latest_version = check_version(zipfile.Path(zip))

print(f"Latest version is {latest_version}")

if current_version != latest_version:
  print(f"Latest version is newer than {current_version}, updating...")

  # NAV doesn't provide stable versioned URLs so we put the download link in Wayback Machine to preserve it.
  print("Archiving...")
  save_api = waybackpy.WaybackMachineSaveAPI(nav_url)

  url = save_api.save()

  print("Prefetching...")
  sha256, unpack_path = subprocess.check_output(["nix-prefetch-url", "--unpack", "--print-path", "--name", "abevjava", url], universal_newlines=True).split("\n")[:2]

  print("Writing version.json...")
  version_path.write_text(json.dumps({
    "url": url,
    "sha256": sha256,
    "version": check_version(Path(unpack_path)),
  }, indent=2) + "\n")
