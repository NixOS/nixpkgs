import plistlib
import re
from base64 import b64encode
from bs4 import BeautifulSoup
from sys import argv
from urllib import request

REGEX_VERSION = re.compile("version = \\\"(.*?)\\\"")
REGEX_HASH = re.compile("hash = \\\"(.*?)\\\"")

def to_sri_hash(algorithm: str, data: str) -> str:
    """Converts a hash from an algorithm and hex string to an SRI hash."""
    data = bytes.fromhex(data)
    data = b64encode(data)
    data = data.decode("ascii")
    return f"{algorithm}-{data}".strip()


def get_version(name: str) -> str:
    """Gets the latest version from the plist file used by the app update checker."""
    url = f"https://www.mothersruin.com/software/{name}/data/{name}VersionInfo.plist"
    with request.urlopen(url) as resp:
        info = plistlib.loads(resp.read())
    return info["CFBundleShortVersionString"]


def get_hash(name: str) -> str:
    """Gets the latest file hash from the app's download page."""
    url = f"https://mothersruin.com/software/{name}/update.html"
    with request.urlopen(url) as resp:
        html = BeautifulSoup(resp.read(), "html.parser")
    sha256 = html.find("td", class_="container-sha256")
    return to_sri_hash("sha256", sha256.string)


def update_file(path: str, new_version: str, new_hash: str):
    """Updates a file with the new version and hash."""
    with open(path, "r") as fp:
        contents = fp.read()

    contents = REGEX_VERSION.sub(f"version = \"{new_version}\"", contents)
    contents = REGEX_HASH.sub(f"hash = \"{new_hash}\"", contents)

    with open(path, "w") as fp:
        fp.write(contents)


def main():
    name = argv[1]
    path = argv[2]

    print(f"Updating {name} ({path})")

    new_version = get_version(name)
    print(f"New version: {new_version}")

    new_hash = get_hash(name)
    print(f"New hash: {new_hash}")

    update_file(path, new_version, new_hash)
    print(f"Successfully updated {name}.")


if __name__ == "__main__":
    main()
