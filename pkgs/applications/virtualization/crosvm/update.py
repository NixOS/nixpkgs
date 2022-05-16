#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git "python3.withPackages (ps: with ps; [ lxml ])"
#! nix-shell -i python

import base64
import csv
import json
import re
import shlex
import subprocess
from os.path import abspath, dirname, splitext
from urllib.request import urlopen

git_path = 'chromiumos/platform/crosvm'
git_root = 'https://chromium.googlesource.com/'
manifest_versions = f'{git_root}chromiumos/manifest-versions'
buildspecs_url = f'{manifest_versions}/+/refs/heads/master/full/buildspecs/'

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
chromeos_tip_build = str(platform_version[0])

# Find the most recent buildspec for the stable Chrome version and
# Chromium OS build number.  Its branch build and branch branch build
# numbers will (almost?) certainly be 0.  It will then end with an rc
# number -- presumably these are release candidates, one of which
# becomes the final release.  Presumably the one with the highest rc
# number.
with urlopen(f'{buildspecs_url}{chrome_major_version}/?format=TEXT') as resp:
    listing = base64.decodebytes(resp.read()).decode('utf-8')
    buildspecs = [(line.split('\t', 1)[1]) for line in listing.splitlines()]
    buildspecs = [s for s in buildspecs if s.startswith(f"{chromeos_tip_build}.")]
    buildspecs.sort(reverse=True)
    buildspec = splitext(buildspecs[0])[0]

# Read the buildspec, and extract the git revision.
with urlopen(f'{buildspecs_url}{chrome_major_version}/{buildspec}.xml?format=TEXT') as resp:
    xml = base64.decodebytes(resp.read())
    root = etree.fromstring(xml)
    revision = root.find(f'./project[@name="{git_path}"]').get('revision')

# Initialize the data that will be output from this script.  Leave the
# rc number in buildspec so nobody else is subject to the same level
# of confusion I have been.
data = {'version': f'{chrome_major_version}.{buildspec}'}

# Fill in the 'src' key with the output from nix-prefetch-git, which
# can be passed straight to fetchGit when imported by Nix.
argv = ['nix-prefetch-git',
        '--fetch-submodules',
        '--url', git_root + git_path,
        '--rev', revision]
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
