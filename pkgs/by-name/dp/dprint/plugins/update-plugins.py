#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix 'python3.withPackages (ps: [ ps.requests ])'

import json
import os
from pathlib import Path
import sys
import subprocess
import requests

USAGE = """Usage: {0} [ | plugin-name | plugin-file-path]

eg.
  {0}
  {0} dprint-plugin-json
  {0} /path/to/dprint-plugin-json.nix"""

FILE_PATH = Path(os.path.realpath(__file__))
SCRIPT_DIR = FILE_PATH.parent

pname = ""
if len(sys.argv) > 1:
    if "-help" in "".join(sys.argv):
        print(USAGE.format(FILE_PATH.name))
        exit(0)
    pname = sys.argv[1]
else:
    pname = os.environ.get("UPDATE_NIX_PNAME", "")


# get sri hash for a url, no unpack
def nix_prefetch_url(url, algo="sha256"):
    hash = (
        subprocess.check_output(["nix-prefetch-url", "--type", algo, url])
        .decode("utf-8")
        .rstrip()
    )
    sri = (
        subprocess.check_output(
            # split by space is enough for this command
            "nix --extra-experimental-features nix-command "
            f"hash convert --hash-algo {algo} --to sri {hash}".split(" ")
        )
        .decode("utf-8")
        .rstrip()
    )
    return sri


# json object to nix string
def json_to_nix(jsondata):
    # to quote strings, dumps twice does it
    json_str = json.dumps(json.dumps(jsondata))
    return (
        subprocess.check_output(
            "nix --extra-experimental-features nix-command eval "
            f"--expr 'builtins.fromJSON ''{json_str}''' --impure | nixfmt",
            shell=True,
        )
        .decode("utf-8")
        .rstrip()
    )


# nix string to json object
def nix_to_json(nixstr):
    return json.loads(
        subprocess.check_output(
            f"nix --extra-experimental-features nix-command eval --json --expr '{nixstr}'",
            shell=True,
        )
        .decode("utf-8")
        .rstrip()
    )


# nixfmt a file
def nixfmt(nixfile):
    subprocess.run(["nixfmt", nixfile])


def get_update_url(plugin_url):
    """Get a single plugin's update url given the plugin's url"""

    # remove -version.wasm at the end
    url = "-".join(plugin_url.split("-")[:-1])
    names = url.split("/")[3:]
    # if single name then -> dprint/<name>
    if len(names) == 1:
        names.insert(0, "dprint")
    return "https://plugins.dprint.dev/" + "/".join(names) + "/latest.json"


def write_plugin_derivation(drv_attrs):
    drv = f"{{ mkDprintPlugin }}: mkDprintPlugin {json_to_nix(drv_attrs)}"
    filepath = SCRIPT_DIR / f"{drv_attrs["pname"]}.nix"
    with open(filepath, "w+", encoding="utf8") as f:
        f.write(drv)
    nixfmt(filepath)


def update_plugin_by_name(name):
    """Update a single plugin by name"""

    # allow passing in filename as well as pname
    if name.endswith(".nix"):
        name = Path(name[:-4]).name
    try:
        p = (SCRIPT_DIR / f"{name}.nix").read_text().replace("\n", "")
    except OSError as e:
        print(f"failed to update plugin {name}: error: {e}")
        exit(1)

    start_idx = p.find("mkDprintPlugin {") + len("mkDprintPlugin {")
    p = nix_to_json("{" + p[start_idx:].strip())

    data = requests.get(p["updateUrl"]).json()
    p["url"] = data["url"]
    p["version"] = data["version"]
    p["hash"] = nix_prefetch_url(data["url"])

    write_plugin_derivation(p)


def update_plugins():
    """Update all the plugins"""

    data = requests.get("https://plugins.dprint.dev/info.json").json()["latest"]

    for e in data:
        update_url = get_update_url(e["url"])
        pname = e["name"]
        if "/" in e["name"]:
            pname = pname.replace("/", "-")
        drv_attrs = {
            "url": e["url"],
            "hash": nix_prefetch_url(e["url"]),
            "updateUrl": update_url,
            "pname": pname,
            "version": e["version"],
            "description": e["description"].rstrip("."),
            "initConfig": {
                "configKey": e["configKey"],
                "configExcludes": e["configExcludes"],
                "fileExtensions": e["fileExtensions"],
            },
        }
        write_plugin_derivation(drv_attrs)


if pname != "":
    update_plugin_by_name(pname)
else:
    update_plugins()
