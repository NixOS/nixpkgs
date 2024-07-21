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

# Official rss/atom feed taken from <https://chromereleases.googleblog.com/>'s html source (<link type="application/atom+xml">)
feed = feedparser.parse('https://www.blogger.com/feeds/8982037438137564684/posts/default')
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
    if fixes := re.search(r'This update includes .+ security fix(es)?\.', content):
        fixes = fixes.group(0)
        if zero_days := re.search(r'Google is aware( of reports)? th(e|at) .+ in the wild\.', content):
            fixes += " " + zero_days.group(0)
        print('\n' + '\n'.join(textwrap.wrap(fixes, width=72)))
    if cve_list := re.findall(r'CVE-[^: ]+', content):
        cve_list = list(OrderedDict.fromkeys(cve_list))  # Remove duplicates but preserve the order
        cve_string = ' '.join(cve_list)
        print("\nCVEs:\n" + '\n'.join(textwrap.wrap(cve_string, width=72)))
    sys.exit(0)  # We only care about the most recent stable channel update

print("Error: No match.")
sys.exit(1)
