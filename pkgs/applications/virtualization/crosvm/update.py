#! /usr/bin/env nix-shell
#! nix-shell -p common-updater-scripts python3
#! nix-shell -i python

import csv
import json
import re
import shlex
import subprocess
from os.path import abspath, dirname, splitext
from urllib.request import urlopen

# CrOS version numbers look like this:
# [<chrome-major-version>.]<tip-build>.<branch-build>.<branch-branch-build>
#
# As far as I can tell, branches are where internal Google
# modifications are added to turn Chromium OS into Chrome OS, and
# branch branches are used for fixes for specific devices.  So for
# Chromium OS they will always be 0.  This is a best guess, and is not
# documented.
with urlopen('https://chromiumdash.appspot.com/cros/download_serving_builds_csv?deviceCategory=ChromeOS') as resp:
    reader = csv.reader(map(bytes.decode, resp))
    header = reader.__next__()
    cr_stable_index = header.index('cr_stable')
    cros_stable_index = header.index('cros_stable')
    chrome_version = []
    platform_version = []

    for line in reader:
        this_chrome_version = list(map(int, line[cr_stable_index].split('.')))
        this_platform_version = list(map(int, line[cros_stable_index].split('.')))
        chrome_version = max(chrome_version, this_chrome_version)
        platform_version = max(platform_version, this_platform_version)

chrome_major_version = chrome_version[0]
chromeos_tip_build = platform_version[0]
release_branch = f'release-R{chrome_major_version}-{chromeos_tip_build}.B-chromeos'

# Determine the git revision.
with urlopen(f'https://chromium.googlesource.com/chromiumos/platform/crosvm/+/refs/heads/{release_branch}?format=JSON') as resp:
    resp.readline() # Remove )]}' header
    rev = json.load(resp)['commit']

# Determine the patch version by counting the commits that have been
# added to the release branch since it forked off the chromeos branch.
with urlopen(f'https://chromium.googlesource.com/chromiumos/platform/crosvm/+log/refs/heads/chromeos..{rev}?format=JSON') as resp:
    resp.readline() # Remove )]}' header
    branch_commits = json.load(resp)['log']
    version = f'{chrome_major_version}.{len(branch_commits)}'

# Update the version, git revision, and hash in crosvm's default.nix.
subprocess.run(['update-source-version', 'crosvm', f'--rev={rev}', version])

# Find the path to crosvm's default.nix, so Cargo.lock can be written
# into the same directory.
argv = ['nix-instantiate', '--eval', '--json', '-A', 'crosvm.meta.position']
position = json.loads(subprocess.check_output(argv).decode('utf-8'))
filename = re.match(r'[^:]*', position)[0]

# Generate a Cargo.lock
run = ['.',
       dirname(abspath(__file__)) + '/generate-cargo.sh',
       dirname(filename) + '/Cargo.lock']
expr = '(import ./. {}).crosvm.overrideAttrs (_: { dontCargoSetupPostUnpack = true; })'
subprocess.run(['nix-shell', '-E', expr, '--run', shlex.join(run)])
