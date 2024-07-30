#!/usr/bin/env python

import argparse
from argparse import RawDescriptionHelpFormatter

description = """
Replace a string in one file with a secret from a second file.

Since the secret is read from a file, it won't be leaked through
'/proc/<pid>/cmdline', unlike when 'sed' or 'replace' is used.
"""

parser = argparse.ArgumentParser(
    description=description,
    formatter_class=RawDescriptionHelpFormatter
)
parser.add_argument("string_to_replace", help="the string to replace")
parser.add_argument("secret_file", help="the file containing the secret")
parser.add_argument("file", help="the file to perform the replacement on")
args = parser.parse_args()

with open(args.secret_file) as sf, open(args.file, 'r+') as f:
    old = f.read()
    secret = sf.read().strip("\n")
    new_content = old.replace(args.string_to_replace, secret)
    f.seek(0)
    f.write(new_content)
    f.truncate()
