
import argparse
from functools import partial
import json
from multiprocessing import Pool
import os
import subprocess


def dropPrefix(path, nixPrefix):
  return path[len(nixPrefix + "/"):]

def processItem(item, nixPrefix, outDir):
  os.chdir(outDir)

  narInfoHash = dropPrefix(item["path"], nixPrefix).split("-")[0]

  xzFile = "nar/" + narInfoHash + ".nar.xz"
  with open(xzFile, "w") as f:
    subprocess.run("nix-store --dump %s | xz -c" % item["path"], stdout=f, shell=True)

  fileHash = subprocess.run(
    ["nix-hash", "--base32", "--type", "sha256", "--flat", xzFile],
    capture_output=True
  ).stdout.decode().strip()
  fileSize = os.path.getsize(xzFile)

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
      "References: " + " ".join(dropPrefix(ref, nixPrefix) for ref in item["references"]),
    ]))

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("--num-workers", type=int, default=4, help="Number of worker processes")
  args = parser.parse_args()

  with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
    closures = json.load(f)["closure"]

  outDir = os.environ["out"]
  nixPrefix = os.environ["NIX_STORE"]

  os.chdir(outDir)
  os.makedirs("nar", exist_ok=True)

  with open("nix-cache-info", "w") as f:
    f.write("StoreDir: " + nixPrefix + "\n")

  with Pool(processes=args.num_workers) as pool:
    worker = partial(processItem, nixPrefix=nixPrefix, outDir=outDir)
    pool.map(worker, closures)

if __name__ == "__main__":
  main()
