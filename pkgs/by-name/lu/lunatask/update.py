#!/usr/bin/env nix-shell
#!nix-shell -i python --packages python3 python3Packages.feedparser common-updater-scripts
"""
Parses the latest version from atom feed and runs update-source-version
"""

import subprocess
import feedparser

URL = "https://lunatask.app/releases/atom.xml"

feed = feedparser.parse(URL)

latest_entry = feed.entries[0]

latest_version = latest_entry.title.split()[-1].lstrip("v")

subprocess.run(["update-source-version", "lunatask", latest_version], check=True)
