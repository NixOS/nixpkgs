#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.requests python3.pkgs.xmltodict
import json
import pathlib
import logging
import requests
import sys
import xmltodict
from packaging import version

updates_url = "https://www.jetbrains.com/updates/updates.xml"
versions_file_path = pathlib.Path(__file__).parent.joinpath("versions.json").resolve()

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)


def one_or_more(x):
    return x if isinstance(x, list) else [x]


def download_channels():
    logging.info("Checking for updates from %s", updates_url)
    updates_response = requests.get(updates_url)
    updates_response.raise_for_status()
    root = xmltodict.parse(updates_response.text)
    products = root["products"]["product"]
    return {
        channel["@name"]: channel
        for product in products
        for channel in one_or_more(product["channel"])
    }


def build_version(build):
    build_number = build["@fullNumber"] if "@fullNumber" in build else build["@number"]
    return version.parse(build_number)


def latest_build(channel):
    builds = one_or_more(channel["build"])
    latest = max(builds, key=build_version)
    return latest


def download_sha256(url):
    url = f"{url}.sha256"
    download_response = requests.get(url)
    download_response.raise_for_status()
    return download_response.content.decode('UTF-8').split(' ')[0]


channels = download_channels()


def update_product(name, product):
    update_channel = product["update-channel"]
    logging.info("Updating %s", name)
    channel = channels.get(update_channel)
    if channel is None:
        logging.error("Failed to find channel %s.", update_channel)
        logging.error("Check that the update-channel in %s matches the name in %s", versions_file_path, updates_url)
    else:
        try:
            build = latest_build(channel)
            new_version = build["@version"]
            new_build_number = build["@fullNumber"]
            if "EAP" not in channel["@name"]:
                version_or_build_number = new_version
            else:
                version_or_build_number = new_build_number
            version_number = new_version.split(' ')[0]
            download_url = product["url-template"].format(version=version_or_build_number, versionMajorMinor=version_number)
            product["url"] = download_url
            if "sha256" not in product or product.get("build_number") != new_build_number:
                logging.info("Found a newer version %s with build number %s.", new_version, new_build_number)
                product["version"] = new_version
                product["build_number"] = new_build_number
                product["sha256"] = download_sha256(download_url)
            else:
                logging.info("Already at the latest version %s with build number %s.", new_version, new_build_number)
        except Exception as e:
            logging.exception("Update failed:", exc_info=e)
            logging.warning("Skipping %s due to the above error.", name)
            logging.warning("It may be out-of-date. Fix the error and rerun.")


def update_products(products):
    for name, product in products.items():
        update_product(name, product)


with open(versions_file_path, "r") as versions_file:
    versions = json.load(versions_file)

for products in versions.values():
    update_products(products)

with open(versions_file_path, "w") as versions_file:
    json.dump(versions, versions_file, indent=2)
    versions_file.write("\n")
