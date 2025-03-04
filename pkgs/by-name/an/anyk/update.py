#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (p: [p.waybackpy])"
import subprocess
from pathlib import Path
import re
import json
import waybackpy

# NAV doesn't provide stable versioned URLs so we put the download link in Wayback Machine to preserve it.

print("Archiving...")
save_api = waybackpy.WaybackMachineSaveAPI("https://nav.gov.hu/pfile/programFile?path=/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava")

url = save_api.save()

print("Prefetching...")
sha256, unpack_path = subprocess.check_output(["nix-prefetch-url", "--unpack", "--print-path", "--name", "abevjava", url], universal_newlines=True).split("\n")[:2]

print("Extracting version...")
manifest = (Path(unpack_path) / "META-INF" / "MANIFEST.MF").read_text()

version = re.search("Implementation-Version: (.+)", manifest).group(1)

print("Writing version.json...")
(Path(__file__).parent / "version.json").write_text(json.dumps({
  "url": url,
  "sha256": sha256,
  "version": version,
}, indent=2) + "\n")
