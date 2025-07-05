#! /usr/bin/env nix-shell
#! nix-shell -i python3 --packages 'python3.withPackages (ps: with ps; [ requests beautifulsoup4 ])'
import os
import re
import json
import requests
from bs4 import BeautifulSoup

SITE = "https://download.racket-lang.org"
MANIFEST_FILENAME = "manifest.json"

def find_info(table, group_name, subgroup_name):
    group = table.find(
        string=re.compile("^{}\\s*".format(group_name))
       ).find_parent("tr", class_="group")
    subgroup = group.find_next(
        string=re.compile("^{}\\s*".format(subgroup_name))
       ).find_parent(class_="subgroup")
    link = subgroup.find_next(
        "a",
        class_="installer",
        string="Source"
       )
    filename = link["href"].split("/")[1]
    sha256 = link.find_next(class_="checksum").string

    return {
        "filename": filename,
        "sha256": sha256,
    }

os.chdir(os.path.dirname(os.path.abspath(__file__)))

prev_version = os.environ["UPDATE_NIX_OLD_VERSION"]

homepage = BeautifulSoup(requests.get(SITE).text, "html.parser")

version = homepage.find(
    "h3",
    string=re.compile("^Version \\d+\\.\\d+")
).string.split()[1]
if version == prev_version:
    raise Exception("no newer version available")

down_page_path = homepage.find(
    "a",
    string="More Installers and Checksums"
)["href"]
down_page = BeautifulSoup(requests.get(SITE + "/" + down_page_path).text, "html.parser")
down_table = down_page.find(class_="download-table")

full = find_info(down_table, "Racket", "Unix")
minimal = find_info(down_table, "Minimal Racket", "All Platforms")

with open(MANIFEST_FILENAME, "w", encoding="utf-8") as f:
    json.dump({
        "version": version,
        "full": full,
        "minimal": minimal,
    }, f, indent=2, ensure_ascii=False)
    f.write("\n")

print(json.dumps(
    [
        {
            "attrPath": os.environ["UPDATE_NIX_ATTR_PATH"],
            "oldVersion": prev_version,
            "newVersion": version,
            "files": [ os.path.abspath(MANIFEST_FILENAME) ],
        },
    ],
    indent=2, ensure_ascii=False
))
