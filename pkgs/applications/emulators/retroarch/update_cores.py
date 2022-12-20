#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../ -i python3 -p "python3.withPackages (ps: with ps; [ requests nix-prefetch-github ])" -p "git"

import json
import os
import subprocess
import sys
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

SCRIPT_PATH = Path(__file__).absolute().parent
HASHES_PATH = SCRIPT_PATH / "hashes.json"
GET_REPO_THREADS = int(os.environ.get("GET_REPO_THREADS", 8))
CORES = {
    "atari800": {"repo": "libretro-atari800"},
    "beetle-gba": {"repo": "beetle-gba-libretro"},
    "beetle-lynx": {"repo": "beetle-lynx-libretro"},
    "beetle-ngp": {"repo": "beetle-ngp-libretro"},
    "beetle-pce-fast": {"repo": "beetle-pce-fast-libretro"},
    "beetle-pcfx": {"repo": "beetle-pcfx-libretro"},
    "beetle-psx": {"repo": "beetle-psx-libretro"},
    "beetle-saturn": {"repo": "beetle-saturn-libretro"},
    "beetle-snes": {"repo": "beetle-bsnes-libretro"},
    "beetle-supafaust": {"repo": "supafaust"},
    "beetle-supergrafx": {"repo": "beetle-supergrafx-libretro"},
    "beetle-vb": {"repo": "beetle-vb-libretro"},
    "beetle-wswan": {"repo": "beetle-wswan-libretro"},
    "blastem": {"repo": "blastem"},
    "bluemsx": {"repo": "bluemsx-libretro"},
    "bsnes": {"repo": "bsnes-libretro"},
    "bsnes-hd": {"repo": "bsnes-hd", "owner": "DerKoun"},
    "bsnes-mercury": {"repo": "bsnes-mercury"},
    "citra": {"repo": "citra", "fetch_submodules": True},
    "desmume": {"repo": "desmume"},
    "desmume2015": {"repo": "desmume2015"},
    "dolphin": {"repo": "dolphin"},
    "dosbox": {"repo": "dosbox-libretro"},
    "eightyone": {"repo": "81-libretro"},
    "fbalpha2012": {"repo": "fbalpha2012"},
    "fbneo": {"repo": "fbneo"},
    "fceumm": {"repo": "libretro-fceumm"},
    "flycast": {"repo": "flycast"},
    "fmsx": {"repo": "fmsx-libretro"},
    "freeintv": {"repo": "freeintv"},
    "gambatte": {"repo": "gambatte-libretro"},
    "genesis-plus-gx": {"repo": "Genesis-Plus-GX"},
    "gpsp": {"repo": "gpsp"},
    "gw": {"repo": "gw-libretro"},
    "handy": {"repo": "libretro-handy"},
    "hatari": {"repo": "hatari"},
    "mame": {"repo": "mame"},
    "mame2000": {"repo": "mame2000-libretro"},
    "mame2003": {"repo": "mame2003-libretro"},
    "mame2003-plus": {"repo": "mame2003-plus-libretro"},
    "mame2010": {"repo": "mame2010-libretro"},
    "mame2015": {"repo": "mame2015-libretro"},
    "mame2016": {"repo": "mame2016-libretro"},
    "melonds": {"repo": "melonds"},
    "mesen": {"repo": "mesen"},
    "mesen-s": {"repo": "mesen-s"},
    "meteor": {"repo": "meteor-libretro"},
    "mgba": {"repo": "mgba"},
    "mupen64plus": {"repo": "mupen64plus-libretro-nx"},
    "neocd": {"repo": "neocd_libretro"},
    "nestopia": {"repo": "nestopia"},
    "nxengine": {"repo": "nxengine-libretro"},
    "np2kai": {"repo": "NP2kai", "owner": "AZO234", "fetch_submodules": True},
    "o2em": {"repo": "libretro-o2em"},
    "opera": {"repo": "opera-libretro"},
    "parallel-n64": {"repo": "parallel-n64"},
    "pcsx2": {"repo": "pcsx2"},
    "pcsx_rearmed": {"repo": "pcsx_rearmed"},
    "picodrive": {"repo": "picodrive", "fetch_submodules": True},
    "play": {"repo": "Play-", "owner": "jpd002", "fetch_submodules": True},
    "ppsspp": {"repo": "ppsspp", "owner": "hrydgard", "fetch_submodules": True},
    "prboom": {"repo": "libretro-prboom"},
    "prosystem": {"repo": "prosystem-libretro"},
    "puae": {"repo": "libretro-uae"},
    "quicknes": {"repo": "QuickNES_Core"},
    "sameboy": {"repo": "sameboy"},
    "scummvm": {"repo": "scummvm"},
    "smsplus-gx": {"repo": "smsplus-gx"},
    "snes9x": {"repo": "snes9x", "owner": "snes9xgit"},
    "snes9x2002": {"repo": "snes9x2002"},
    "snes9x2005": {"repo": "snes9x2005"},
    "snes9x2010": {"repo": "snes9x2010"},
    "stella": {"repo": "stella", "owner": "stella-emu"},
    "stella2014": {"repo": "stella2014-libretro"},
    "swanstation": {"repo": "swanstation"},
    "tgbdual": {"repo": "tgbdual-libretro"},
    "thepowdertoy": {"repo": "ThePowderToy"},
    "tic80": {"repo": "tic-80", "fetch_submodules": True},
    "vba-m": {"repo": "vbam-libretro"},
    "vba-next": {"repo": "vba-next"},
    "vecx": {"repo": "libretro-vecx"},
    "virtualjaguar": {"repo": "virtualjaguar-libretro"},
    "yabause": {"repo": "yabause"},
}


def info(*msg):
    print(*msg, file=sys.stderr)


def get_repo_hash_fetchFromGitHub(
    repo,
    owner="libretro",
    deep_clone=False,
    fetch_submodules=False,
    leave_dot_git=False,
    rev=None,
):
    extra_args = []
    if deep_clone:
        extra_args.append("--deep-clone")
    else:
        extra_args.append("--no-deep-clone")
    if fetch_submodules:
        extra_args.append("--fetch-submodules")
    else:
        extra_args.append("--no-fetch-submodules")
    if leave_dot_git:
        extra_args.append("--leave-dot-git")
    else:
        extra_args.append("--no-leave-dot-git")
    if rev:
        extra_args.append("--rev")
        extra_args.append(rev)
    result = subprocess.run(
        ["nix-prefetch-github", owner, repo, *extra_args],
        check=True,
        capture_output=True,
        text=True,
    )
    j = json.loads(result.stdout)
    # Remove False values
    return {k: v for k, v in j.items() if v}


def get_repo_hash(fetcher="fetchFromGitHub", **kwargs):
    if fetcher == "fetchFromGitHub":
        return get_repo_hash_fetchFromGitHub(**kwargs)
    else:
        raise ValueError(f"Unsupported fetcher: {fetcher}")


def get_repo_hashes(cores={}):
    def get_repo_hash_from_core_def(core_def):
        core, repo = core_def
        info(f"Getting repo hash for '{core}'...")
        result = core, get_repo_hash(**repo)
        info(f"Got repo hash for '{core}'!")
        return result

    with open(HASHES_PATH) as f:
        repo_hashes = json.loads(f.read())

    info(f"Running with {GET_REPO_THREADS} threads!")
    with ThreadPoolExecutor(max_workers=GET_REPO_THREADS) as executor:
        new_repo_hashes = executor.map(get_repo_hash_from_core_def, cores.items())

    for core, repo in new_repo_hashes:
        repo_hashes[core] = repo

    return repo_hashes


def main():
    # If you don't want to update all cores, pass the name of the cores you
    # want to update on the command line. E.g.:
    # $ ./update.py citra snes9x
    if len(sys.argv) > 1:
        cores_to_update = sys.argv[1:]
    else:
        cores_to_update = CORES.keys()

    cores = {core: repo for core, repo in CORES.items() if core in cores_to_update}
    repo_hashes = get_repo_hashes(cores)
    info(f"Generating '{HASHES_PATH}'...")
    with open(HASHES_PATH, "w") as f:
        f.write(json.dumps(dict(sorted(repo_hashes.items())), indent=4))
        f.write("\n")
    info("Finished!")


if __name__ == "__main__":
    main()
