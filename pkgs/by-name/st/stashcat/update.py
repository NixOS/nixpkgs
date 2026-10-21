#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.packaging python3Packages.python-debian common-updater-scripts gnupg

import hashlib
import os
import subprocess
import sys
import tempfile
from collections import OrderedDict
from urllib import request

from debian.deb822 import Packages, Release
from debian.debian_support import Version

# The repo is http-only, so Packages (which carries the actual download
# hashes) is verified against the gpg-signed Release file before use.
DIST_URL = "http://deb.stashcat.com/repo01/dists/stashcat-dc"
PACKAGES_PATH = "main/binary-amd64/Packages"

# The stashcat repo signing key, manually checked against
# http://deb.stashcat.com/stashcat.repo.key (fingerprint 653E 2B89 57B7 1342
# 43AF 2DC2 FA67 1F46 5250 5E5B). Kept inline rather than fetched at update
# time, so a compromise of that URL can't silently swap in a different key.
PUBKEY = """\
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBGFESk0BEADGIWFcUC6F9aggJ8Uka1qLNM2Pco9hHklxE73VwG9SJjeF9yTq
rYwoOMd1Q1EK3se/BFJ/I8g5ash8dShacAQZA6AxXcLXDJ1laGBVH6X1fde72iCZ
FFz7nSh3AVkbpnOVx31zSZI/v39UOKKRl9/6GRAquxKGi4tNk9mDlNEGR/U3j5wH
u8Mvpj0k13I0sDvJG4+sPaDQQsXrKO5CxA6yjVh6lYNIDGQaCOSzhQ79JasZNqoK
1/LqBhUN2rLAuVUGxb5QtghbQaff5y8Nq4E5ZLBgWd2dyFPtWKBjx9aJWr+1XWeP
ZcVxHAfzH4NrYtsqLAOJ5KpD5uOtOwGr+SwL6VGYT6tm9gVHWQ3EtNeoVlgwlDEm
yzzOvwnKgvdZMGXfky1OaiEPd5/wMoAb0b4kZsIraguAR64xZWUldKKzhRawo3Zf
8Vz+o/njdOdTUu2MoQEkILbBlSkq8GyjyZJfBFHVHYijQloBa4nwWmPQrUPQAXs2
6uRBQuZwofAO5i84G/pvgLXpDx9wsVKo23qoWj9LlA5ozfy6SvK0+NPPR2w/WPPD
b3dkaqIPzEFJUuWh5hjtasgVl4dIHmQdy6igc4GRDxfUY68VDIY3X2ZcCshm/TtA
CJx/j4MXkYMjdyDMsHN1Uq3MZ/UgKdvNeZqobnD1X50cPvj1VsdfKpTZ6QARAQAB
tCxzdGFzaGNhdCBkZWIgcmVwb3NpdG9yeSA8aGVsbG9Ac3Rhc2hjYXQuY29tPokC
VAQTAQoAPhYhBGU+K4lXtxNCQ68twvpnH0ZSUF5bBQJhREpNAhsDBQmTQWPzBQsJ
CAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEPpnH0ZSUF5bIKIP/2MOz0ujjtJsuDV0
iUhKD5szlHEgztAv+STF9dGN8dns1z9XXtMtIZ/OWrMfXyNfUk/VodDP9ZhPMSTl
tS0oDbP3+o3VqfgYyNsr0UplASLnm7/anMDN+KBCQ+c1NMX/gmGqreYj67ayN/Ui
h2+DqmVqAsboO8Qco6aMv9xcV29W90/VTOYIfaTLVLpRkkXUWMnNFdNcFsqQn6mY
KIbuHKJlO48vstyLsQ6TyV3cnDcsz5l3mJrChM6mNVt2sZ12NSncPJpCgcCDMr9Z
JjPEcixXHkEHnC4j92VypswIsXzv0JxWFNsF8YqZnFFVTiFbttEgL+6ca2c1J0Fx
zd/zjjxTwa7s0y4R6QSJ0TIW/GHbcYYfn+c9nXXCkWjEhEhLS0D6epRVXLJP+h4c
pcGj51VaVz3NYpLofkNYN71tQNwsKibvSV+6xjX05ZhF0a82UVRyixnqz0CrSb9V
2UsU5RJTWfyFvVUQqxdX4kDqEox5yGLWBtPsquKXyRvIUQ9XaI9kYNSgXPHoE0+Y
Y1kf+mUjLuPa+MDOXJbfiSVPoQXB28qz3dLQnMqsMRr0FHk+kWoPn8iQWhLS6Qoo
Nqoy3t5/LKl+X4jnhJd8lXobVdIFzVfp2m6qA3J5+cvnNcG7x+5ypFpV8ExY+Z+M
iGhbuJoJfA31LPYASY9cXq7XxZGU
=njOg
-----END PGP PUBLIC KEY BLOCK-----
"""


def fetch(url: str) -> bytes:
    with request.urlopen(url) as handle:
        return handle.read()


def verify_release_signature(release: bytes, signature: bytes, pubkey: bytes):
    print("Verifying signature of Release file")
    # Use gpgv to check a detached signature directly against a keyring file,
    # with no import step and no persistent trust database.
    with tempfile.TemporaryDirectory() as tmp:
        release_file = os.path.join(tmp, "Release")
        sig_file = os.path.join(tmp, "Release.gpg")
        keyring_file = os.path.join(tmp, "keyring.gpg")
        with open(release_file, "wb") as f:
            f.write(release)
        with open(sig_file, "wb") as f:
            f.write(signature)

        dearmor = subprocess.run(
            ["gpg", "--homedir", tmp, "--dearmor"],
            input=pubkey,
            capture_output=True,
            check=True,
        )
        with open(keyring_file, "wb") as f:
            f.write(dearmor.stdout)

        result = subprocess.run(
            ["gpgv", "--keyring", keyring_file, sig_file, release_file],
            capture_output=True,
        )
        if result.returncode != 0:
            sys.exit(
                "stashcat: Release signature verification failed:\n"
                + result.stderr.decode(errors="replace")
            )


def verified_packages() -> bytes:
    # Exits the whole script (via subprocess `check=True` or explicit
    # sys.exit calls) if any verification step below fails.

    print("Fetching deb repo Release file")
    release = fetch(f"{DIST_URL}/Release")
    print("Fetching deb repo Release.gpg file")
    signature = fetch(f"{DIST_URL}/Release.gpg")
    verify_release_signature(release, signature, PUBKEY.encode())

    checksums = {entry["name"]: entry["sha512"] for entry in Release(release)["SHA512"]}
    if PACKAGES_PATH not in checksums:
        sys.exit(f"stashcat: {PACKAGES_PATH} missing from Release SHA512 checksums")

    print("Fetching deb repo Packages file")
    packages = fetch(f"{DIST_URL}/{PACKAGES_PATH}")
    print("Checking checksum of Packages file against Release file")
    digest = hashlib.sha512(packages).hexdigest()
    if digest != checksums[PACKAGES_PATH]:
        sys.exit(
            f"stashcat: SHA512 mismatch for {PACKAGES_PATH}: "
            f"expected {checksums[PACKAGES_PATH]}, got {digest}"
        )
    return packages


def latest_packages(packages: bytes):
    latest_packages: OrderedDict[str, Packages] = {}
    for package in Packages.iter_paragraphs(packages, use_apt_pkg=False):
        name: str = package["Package"]
        if not name.startswith("stashcat"):
            continue
        channel = "stable"  # It's the only channel
        if channel not in latest_packages:
            latest_packages[channel] = package
        else:
            old_package = latest_packages[channel]
            if old_package.get_version() < package.get_version():  # type: ignore
                latest_packages[channel] = package
    return OrderedDict(sorted(latest_packages.items(), key=lambda x: x[0]))

def convert_hash_to_sri(pkg_hash):
    sri_result = subprocess.run(
        ["nix", "hash", "to-sri", f"sha512:{pkg_hash}"], capture_output=True, text=True
    )
    sri_result.check_returncode()
    return sri_result.stdout.strip()

def write_expression():
    latest = latest_packages(verified_packages())
    version = Version.re_valid_version.match(latest["stable"]["Version"]).group(
        "upstream_version"
    )
    print(f"Latest version from deb repo: {version}")
    hash_value = convert_hash_to_sri(latest["stable"]["SHA512"])

    subprocess.run(
        [
            "update-source-version",
            "stashcat",
            version,
            hash_value
        ],
        check=True,
    )

write_expression()
