#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3Packages.feedparser python3Packages.requests

# This script prints the Git commit message for stable channel updates.

import re
import textwrap

from collections import OrderedDict

import feedparser
import requests

feed = feedparser.parse('https://chromereleases.googleblog.com/feeds/posts/default')
html_tags = re.compile(r'<[^>]+>')

for entry in feed.entries:
    if entry.title != 'Stable Channel Update for Desktop':
        continue
    url = requests.get(entry.link).url.split('?')[0]
    content = entry.content[0].value
    if re.search(r'Linux', content) is None:
        continue
    #print(url)  # For debugging purposes
    version = re.search(r'\d+(\.\d+){3}', content).group(0)
    print('chromium: TODO -> ' + version)
    print('\n' + url)
    if fixes := re.search(r'This update includes .+ security fixes\.', content):
        fixes = html_tags.sub('', fixes.group(0))
        zero_days = re.search(r'Google is aware of reports that .+ in the wild\.', content)
        if zero_days:
            fixes += " " + zero_days.group(0)
        print('\n' + '\n'.join(textwrap.wrap(fixes, width=72)))
    if cve_list := re.findall(r'CVE-[^: ]+', content):
        cve_list = list(OrderedDict.fromkeys(cve_list))  # Remove duplicates but preserve the order
        cve_string = ' '.join(cve_list)
        print("\nCVEs:\n" + '\n'.join(textwrap.wrap(cve_string, width=72)))
    break  # We only care about the most recent stable channel update
