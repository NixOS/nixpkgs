
import json
import os
import subprocess

with open(".attrs.json", "r") as f:
  closures = json.load(f)["closure"]

os.chdir(os.environ["out"])

nixPrefix = os.environ["NIX_STORE"] # Usually /nix/store

with open("nix-cache-info", "w") as f:
  f.write("StoreDir: " + nixPrefix + "\n")

def dropPrefix(path):
  return path[len(nixPrefix + "/"):]

for item in closures:
  narInfoHash = dropPrefix(item["path"]).split("-")[0]

  xzFile = "nar/" + narInfoHash + ".nar.xz"
  with open(xzFile, "w") as f:
    subprocess.run("nix-store --dump %s | xz -c" % item["path"], stdout=f, shell=True)

  fileHash = subprocess.run(["nix-hash", "--base32", "--type", "sha256", item["path"]], capture_output=True).stdout.decode().strip()
  fileSize = os.path.getsize(xzFile)

  # Rename the .nar.xz file to its own hash to match "nix copy" behavior
  finalXzFile = "nar/" + fileHash + ".nar.xz"
  os.rename(xzFile, finalXzFile)

  with open(narInfoHash + ".narinfo", "w") as f:
    f.writelines((x + "\n" for x in [
      "StorePath: " + item["path"],
      "URL: " + finalXzFile,
      "Compression: xz",
      "FileHash: sha256:" + fileHash,
      "FileSize: " + str(fileSize),
      "NarHash: " + item["narHash"],
      "NarSize: " + str(item["narSize"]),
      "References: " + " ".join(dropPrefix(ref) for ref in item["references"]),
    ]))
