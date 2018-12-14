#! /usr/bin/env nix-shell
#! nix-shell -p python3 -p nix-prefetch-git -i python

import base64
import csv
import json
import re
import subprocess
import xml.etree.ElementTree as ElementTree
from codecs import iterdecode
from operator import itemgetter
from os.path import dirname, splitext
from urllib.request import urlopen

# ChromiumOS components required to build crosvm.
components = ['chromiumos/platform/crosvm', 'chromiumos/third_party/adhd']

git_root = 'https://chromium.googlesource.com/'
manifest_versions = f'{git_root}chromiumos/manifest-versions'
buildspecs_url = f'{manifest_versions}/+/refs/heads/master/paladin/buildspecs/'

# CrOS version numbers look like this:
# [<chrome-major-version>.]<tip-build>.<branch-build>.<branch-branch-build>
#
# As far as I can tell, branches are where internal Google
# modifications are added to turn Chromium OS into Chrome OS, and
# branch branches are used for fixes for specific devices.  So for
# Chromium OS they will always be 0.  This is a best guess, and is not
# documented.
with urlopen('https://cros-omahaproxy.appspot.com/all') as resp:
    versions = csv.DictReader(iterdecode(resp, 'utf-8'))
    stables = filter(lambda v: v['track'] == 'stable-channel', versions)
    stable = sorted(stables, key=itemgetter('chrome_version'), reverse=True)[0]

chrome_major_version = re.match(r'\d+', stable['chrome_version'])[0]
chromeos_tip_build = re.match(r'\d+', stable['chromeos_version'])[0]

# Find the most recent buildspec for the stable Chrome version and
# Chromium OS build number.  Its branch build and branch branch build
# numbers will (almost?) certainly be 0.  It will then end with an rc
# number -- presumably these are release candidates, one of which
# becomes the final release.  Presumably the one with the highest rc
# number.
with urlopen(f'{buildspecs_url}{chrome_major_version}/?format=TEXT') as resp:
    listing = base64.decodebytes(resp.read()).decode('utf-8')
    buildspecs = [(line.split('\t', 1)[1]) for line in listing.splitlines()]
    buildspecs = [s for s in buildspecs if s.startswith(chromeos_tip_build)]
    buildspecs.sort(reverse=True)
    buildspec = splitext(buildspecs[0])[0]

revisions = {}

# Read the buildspec, and extract the git revisions for each component.
with urlopen(f'{buildspecs_url}{chrome_major_version}/{buildspec}.xml?format=TEXT') as resp:
    xml = base64.decodebytes(resp.read()).decode('utf-8')
    root = ElementTree.fromstring(xml)
    for project in root.findall('project'):
        revisions[project.get('name')] = project.get('revision')

# Initialize the data that will be output from this script.  Leave the
# rc number in buildspec so nobody else is subject to the same level
# of confusion I have been.
data = {'version': f'{chrome_major_version}.{buildspec}', 'components': {}}

# Fill in the 'components' dictionary with the output from
# nix-prefetch-git, which can be passed straight to fetchGit when
# imported by Nix.
for component in components:
    argv = ['nix-prefetch-git',
            '--url', git_root + component,
            '--rev', revisions[component]]

    output = subprocess.check_output(argv)
    data['components'][component] = json.loads(output.decode('utf-8'))

# Find the path to crosvm's default.nix, so the srcs data can be
# written into the same directory.
argv = ['nix-instantiate', '--eval', '--json', '-A', 'crosvm.meta.position']
position = json.loads(subprocess.check_output(argv).decode('utf-8'))
filename = re.match(r'[^:]*', position)[0]

# Finally, write the output.
with open(dirname(filename) + '/upstream-info.json', 'w') as out:
    json.dump(data, out, indent=2)
    out.write('\n')
