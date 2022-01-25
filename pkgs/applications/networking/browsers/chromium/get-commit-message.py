#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3Packages.feedparser python3Packages.requests

# This script prints the Git commit message for stable channel updates.
# Usage: ./get-commit-message.py [version]

import re
import sys
import textwrap

from collections import OrderedDict

import feedparser
import requests

feed = feedparser.parse('https://chromereleases.googleblog.com/feeds/posts/default')
html_tags = re.compile(r'<[^>]+>')
target_version = sys.argv[1] if len(sys.argv) == 2 else None

for entry in feed.entries:
    url = requests.get(entry.link).url.split('?')[0]
    if entry.title != 'Stable Channel Update for Desktop':
        if target_version and entry.title == '':
            # Workaround for a special case (Chrome Releases bug?):
            if not 'the-stable-channel-has-been-updated-to' in url:
                continue
        else:
            continue
    content = entry.content[0].value
    content = html_tags.sub('', content)  # Remove any HTML tags
    if re.search(r'Linux', content) is None:
        continue
    #print(url)  # For debugging purposes
    version = re.search(r'\d+(\.\d+){3}', content).group(0)
    if target_version:
        if version != target_version:
            continue
    else:
        print('chromium: TODO -> ' + version + '\n')
    print(url)
    if fixes := re.search(r'This update includes .+ security fixes\.', content).group(0):
        zero_days = re.search(r'Google is aware( of reports)? th(e|at) .+ in the wild\.', content)
        if zero_days:
            fixes += " " + zero_days.group(0)
        print('\n' + '\n'.join(textwrap.wrap(fixes, width=72)))
    if cve_list := re.findall(r'CVE-[^: ]+', content):
        cve_list = list(OrderedDict.fromkeys(cve_list))  # Remove duplicates but preserve the order
        cve_string = ' '.join(cve_list)
        print("\nCVEs:\n" + '\n'.join(textwrap.wrap(cve_string, width=72)))
    sys.exit(0)  # We only care about the most recent stable channel update

print("Error: No match.")
sys.exit(1)
