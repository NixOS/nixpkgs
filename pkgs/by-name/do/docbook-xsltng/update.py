#! /usr/bin/env nix-shell
#! nix-shell -p python3 -i python3

import os
import subprocess
import json
import urllib.request as ureq

MANIFEST_FILENAME = "manifest.json"
RELEASE_INFO_URL = "https://api.github.com/repos/docbook/xslTNG/releases/latest"
ARCHIVE_URL_TEMPLATE = "https://github.com/docbook/xslTNG/archive/refs/tags/{}.zip"
GRADLE_PROPERTIES_URL_TEMPLATE = (
    "https://github.com/docbook/xslTNG/raw/refs/tags/{}/gradle.properties"
)
XSPEC_URL_TEMPLATE = "https://github.com/xspec/xspec/archive/v{}.zip"
XSLT_EXPLORER_URL_TEMPLATE = (
    "https://github.com/ndw/xsltexplorer/releases/download/{0}/xsltexplorer-{0}.zip"
)


def gethash(url, unpack=False):
    sha256 = subprocess.run(
        ["nix-prefetch-url", url] + (["--unpack"] if unpack else []),
        check=True,
        capture_output=True,
        encoding="utf-8",
    ).stdout.strip()
    sri = subprocess.run(
        ["nix-hash", "--to-sri", "--type", "sha256", sha256],
        check=True,
        capture_output=True,
        encoding="utf-8",
    ).stdout.strip()
    return sri


def fetchjson(url):
    with ureq.urlopen(url) as r:
        return json.loads(r.read())


def storejson(path, obj):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f, indent=2)
        f.write("\n")


def findnixroot(startpoint=os.path.dirname(os.path.abspath(__file__))):
    check_dir = startpoint
    while True:
        rootlike = os.path.join(check_dir, "default.nix")
        if os.path.isfile(rootlike):
            return rootlike
        elif os.path.dirname(check_dir) == check_dir:
            raise Exception("fail to find the root directory of the Nix workspace")
        else:
            check_dir = os.path.dirname(check_dir)


os.chdir(os.path.dirname(os.path.abspath(__file__)))

tag_name = fetchjson(RELEASE_INFO_URL)["tag_name"]
with open(MANIFEST_FILENAME, "r") as f:
    former_tag_name = json.load(f)["version"]
if tag_name == former_tag_name:
    raise Exception("no newer version available")

xspec_version = None
xslt_explorer_version = None
for row in ureq.urlopen(GRADLE_PROPERTIES_URL_TEMPLATE.format(tag_name)):
    try:
        key, value = row.decode("utf-8").strip().split("=", maxsplit=1)
        if key == "xspecVersion":
            xspec_version = value
        elif key == "xsltExplorerVersion":
            xslt_explorer_version = value
    except ValueError:
        pass

hash = gethash(ARCHIVE_URL_TEMPLATE.format(tag_name), unpack=True)
xspec_hash = gethash(XSPEC_URL_TEMPLATE.format(xspec_version))
xslt_explorer_hash = gethash(XSLT_EXPLORER_URL_TEMPLATE.format(xslt_explorer_version))

storejson(
    MANIFEST_FILENAME,
    {
        "version": tag_name,
        "hash": hash,
        "dependencies": {
            "xspec": {
                "version": xspec_version,
                "hash": xspec_hash,
            },
            "xsltExplorer": {
                "version": xslt_explorer_version,
                "hash": xslt_explorer_hash,
            },
        },
    },
)

mitm_cache_updater_path = subprocess.run(
    [
        "nix-build",
        findnixroot(),
        "-A",
        os.environ["UPDATE_NIX_ATTR_PATH"] + ".mitmCache.updateScript",
        "--no-out-link",
    ],
    check=True,
    capture_output=True,
    encoding="utf-8",
).stdout.strip()

subprocess.run([mitm_cache_updater_path], check=True)

print(
    json.dumps(
        [
            {
                "attrPath": os.environ["UPDATE_NIX_ATTR_PATH"],
                "oldVersion": former_tag_name,
                "newVersion": tag_name,
            },
        ],
        indent=2,
    )
)
