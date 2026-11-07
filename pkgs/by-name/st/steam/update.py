#!/usr/bin/env nix-shell
#!nix-shell --pure --keep NIX_PATH -i python3 -p common-updater-scripts nix "python3.withPackages (ps: [ ps.vdf ])" cacert

import base64
import io
import subprocess
import urllib.parse
import urllib.request
import zipfile

import vdf

DARWIN_DOWNLOAD = "https://client-update.fastly.steamstatic.com/"
DARWIN_MANIFEST = urllib.parse.urljoin(DARWIN_DOWNLOAD, "steam_client_osx")


def nix_eval(system, attr):
    return subprocess.run(
        [
            "nix-instantiate",
            "--eval",
            "--raw",
            "--argstr",
            "system",
            system,
            "-A",
            f"steam.{attr}",
        ],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()


def update_source_version(version, hash, system, url=None):
    args = [
        "update-source-version",
        "steam",
        version,
        hash,
        f"--system={system}",
        "--ignore-same-version",
    ]
    if url is not None:
        args.append(url)
    subprocess.run(args, check=True)


manifest = vdf.loads(urllib.request.urlopen(DARWIN_MANIFEST).read().decode())
appdmg = manifest["osx"]["appdmg_osx"]
url = urllib.parse.urljoin(DARWIN_DOWNLOAD, appdmg["file"])
hash = "sha256-" + base64.b64encode(bytes.fromhex(appdmg["sha2"])).decode()

current_url = nix_eval("aarch64-darwin", "src.url")
if current_url == url and nix_eval("aarch64-darwin", "src.drvAttrs.outputHash") == hash:
    version = nix_eval("aarch64-darwin", "version")
    print(f"steam Darwin is already at bootstrap {version}")
else:
    archive = urllib.request.urlopen(url).read()
    version = (
        zipfile.ZipFile(io.BytesIO(archive))
        .read("SteamMacBootstrapper.version")
        .decode()
        .strip()
    )

    update_source_version(
        version,
        hash,
        "aarch64-darwin",
        url if current_url != url else None,
    )
    print(f"Updated steam Darwin to bootstrap {version}")
