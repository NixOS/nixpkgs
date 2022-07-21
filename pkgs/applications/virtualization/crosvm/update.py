#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git python3
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

# Determine the patch version by counting the commits that have been
# added to the release branch since it forked off the chromeos branch.
with urlopen(f'https://chromium.googlesource.com/chromiumos/platform/crosvm/+log/refs/heads/chromeos..refs/heads/{release_branch}?format=JSON') as resp:
    resp.readline() # Remove )]}' header
    branch_commits = json.load(resp)['log']
    data = {'version': f'{chrome_major_version}.{len(branch_commits)}'}

# Fill in the 'src' key with the output from nix-prefetch-git, which
# can be passed straight to fetchGit when imported by Nix.
argv = ['nix-prefetch-git',
        '--fetch-submodules',
        '--url', 'https://chromium.googlesource.com/crosvm/crosvm',
        '--rev', f'refs/heads/{release_branch}']
output = subprocess.check_output(argv)
data['src'] = json.loads(output.decode('utf-8'))

# Find the path to crosvm's default.nix, so the src data can be
# written into the same directory.
argv = ['nix-instantiate', '--eval', '--json', '-A', 'crosvm.meta.position']
position = json.loads(subprocess.check_output(argv).decode('utf-8'))
filename = re.match(r'[^:]*', position)[0]

# Write the output.
with open(dirname(filename) + '/upstream-info.json', 'w') as out:
    json.dump(data, out, indent=2)
    out.write('\n')

# Generate a Cargo.lock
run = ['.',
       dirname(abspath(__file__)) + '/generate-cargo.sh',
       dirname(filename) + '/Cargo.lock']
expr = '(import ./. {}).crosvm.overrideAttrs (_: { dontCargoSetupPostUnpack = true; })'
subprocess.run(['nix-shell', '-E', expr, '--run', shlex.join(run)])
