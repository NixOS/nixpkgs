#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p nix-update python3 python3Packages.requests python3.pkgs.tomlkit nix-prefetch-git
import tomlkit
import json
import requests
import subprocess
from pathlib import Path

latest_release_url = "https://api.github.com/repos/helix-editor/helix/releases/latest"


def get_latest_release():
    res = requests.get(latest_release_url)
    res.raise_for_status()
    return res.json()["tag_name"]


def get_grammar_config():
    res = requests.get(f"https://raw.githubusercontent.com/helix-editor/helix/{version}/languages.toml")
    res.raise_for_status()
    return tomlkit.parse(res.text)["grammar"]


def calculate_sha256(url, rev):
    out = subprocess.check_output([
        "nix-prefetch-git", "--quiet",
        "--url", url,
        "--rev", rev])
    return json.loads(out)["sha256"]


version = get_latest_release()
grammars = get_grammar_config()
for grammar in grammars:
    if grammar["source"].get("git") is not None:
        grammar["source"]["sha256"] = calculate_sha256(
            grammar["source"]["git"], grammar["source"]["rev"])

json_grammars = json.dumps(grammars)

with open(Path(__file__).parent / "language-grammars.json", "w") as file:
    file.write(json_grammars + "\n")

subprocess.run([
    "nix-update", "helix",
    "--version", version,
])
