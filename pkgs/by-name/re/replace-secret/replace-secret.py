#!/usr/bin/env python

import argparse
import json
from argparse import BooleanOptionalAction, RawDescriptionHelpFormatter

description = """
Replace a string in one file with a secret from a second file.

Since the secret is read from a file, it won't be leaked through
'/proc/<pid>/cmdline', unlike when 'sed' or 'replace' is used.

Newline characters (\\n) at the end of the secret are removed.
"""

styles = [
    'json',
    'key_value',
]

parser = argparse.ArgumentParser(
    description=description,
    formatter_class=RawDescriptionHelpFormatter
)
parser.add_argument("string_to_replace", help="the string to replace")
parser.add_argument("secret_file", help="the file containing the secret")
parser.add_argument("file", help="the file to perform the replacement on")
parser.add_argument("--quote", help="whether to quote and escape the secret", default=False, action=BooleanOptionalAction)
parser.add_argument("--quote_style", help="the quoting scheme used", choices=styles, default='json')
args = parser.parse_args()

with open(args.secret_file) as sf, open(args.file, 'r+') as f:
    old = f.read()
    secret = sf.read().strip("\n")

    if args.quote_style == "key_value":
        # No quoting before nor after
        pass
    elif args.quote_style == "json":
        # JSON secrets are always quoted so we must replace the quotes too
        args.string_to_replace = f"\"{args.string_to_replace}\""
        if args.quote:
            secret = json.dumps(secret)

    new_content = old.replace(args.string_to_replace, secret)
    f.seek(0)
    f.write(new_content)
    f.truncate()
