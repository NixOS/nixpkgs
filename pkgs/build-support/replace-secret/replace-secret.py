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
parser.add_argument("--prefix", help="add a fixed prefix to the secret", default="")
parser.add_argument("--suffix", help="add a fixed suffix to the secret", default="")
parser.add_argument("--prefix-if-not-present", help="add a prefix to the secret if the secret does not include it already", default="")
parser.add_argument("--suffix-if-not-present", help="add a suffix to the secret if the secret does not include it already", default="")
args = parser.parse_args()

with open(args.secret_file) as sf, open(args.file, 'r+') as f:
    old = f.read()

    secret = sf.read().strip("\n")
    if not secret.startswith(args.prefix_if_not_present):
        secret = args.prefix_if_not_present + secret
    if not secret.endswith(args.suffix_if_not_present):
        secret = secret + args.suffix_if_not_present

    new_content = old.replace(args.string_to_replace, args.prefix + secret + args.suffix)
    f.seek(0)
    f.write(new_content)
    f.truncate()
