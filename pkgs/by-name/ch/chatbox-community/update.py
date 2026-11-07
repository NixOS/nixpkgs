#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p 'python3.withPackages (ps: with ps; [ requests ])' curl nix-prefetch-github npm-lockfile-fix prefetch-npm-deps

import os
import json
import requests
import subprocess

MANIFEST_FILENAME = "manifest.json"
LOCK_FILENAME = "package-lock.json"
OWNER = "chatboxai"
REPO = "chatbox"

os.chdir(os.path.dirname(__file__))

with open(MANIFEST_FILENAME, "r", encoding="utf-8") as f:
    manifest = json.load(f)

commits = requests.get(
    "https://api.github.com/repos/{0}/{1}/commits".format(OWNER, REPO)
).json()

rev, version = None, None
for c in commits:
    if c["commit"]["message"].startswith("release "):
        rev = c["sha"]
        version = c["commit"]["message"].split()[1].removeprefix("v")
        break

if rev is None:
    raise Exception('fail to get a "release" commit')
elif rev.startswith(manifest["rev"]):
    raise Exception("no newer version available")

hash = json.loads(
    subprocess.run(
        ["nix-prefetch-github", OWNER, REPO, "--rev", rev],
        capture_output=True,
        check=True,
        encoding="utf-8",
    ).stdout
)["hash"]

subprocess.run(
    """
    curl -sSL https://raw.githubusercontent.com/{0}/{1}/{2}/{3} > {3}
    npm-lockfile-fix {3} > /dev/null
    """.format(OWNER, REPO, rev, LOCK_FILENAME),
    shell=True,
    check=True,
)

npm_deps_hash = subprocess.run(
    ["prefetch-npm-deps", LOCK_FILENAME],
    capture_output=True,
    check=True,
    encoding="utf-8",
).stdout.strip()

with open(MANIFEST_FILENAME, "w", encoding="utf-8") as f:
    json.dump(
        {
            "version": version,
            "rev": rev,
            "hash": hash,
            "npmDepsHash": npm_deps_hash,
        },
        f,
        indent=2,
    )
    f.write("\n")

print(json.dumps([{}]))
