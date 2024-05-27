
# Convert a list of strings to a regex that matches everything but those strings
# ... and it had to be a POSIX regex; no negative lookahead :(
# This is a workaround for erofs supporting only exclude regex, not an include list

import sys
import re
from collections import defaultdict

# We can configure this script to match in different ways if we need to.
# The regex got too long for the argument list, so we had to truncate the
# hashes and use MATCH_STRING_PREFIX. That's less accurate, and might pick up some
# garbage like .lock files, but only if the sandbox doesn't hide those. Even
# then it should be harmless.

# Produce the negation of ^a$
MATCH_EXACTLY = ".+"
# Produce the negation of ^a
MATCH_STRING_PREFIX = "//X" # //X should be epsilon regex instead. Not supported??
# Produce the negation of ^a/?
MATCH_SUBPATHS = "[^/].*$"

# match_end = MATCH_SUBPATHS
match_end = MATCH_STRING_PREFIX
# match_end = MATCH_EXACTLY

def chars_to_inverted_class(letters):
    assert len(letters) > 0
    letters = list(letters)

    s = "[^"

    if "]" in letters:
        s += "]"
        letters.remove("]")

    final = ""
    if "-" in letters:
        final = "-"
        letters.remove("-")

    s += "".join(letters)

    s += final

    s += "]"

    return s

# There's probably at least one bug in here, but it seems to works well enough
# for filtering store paths.
def strings_to_inverted_regex(strings):
    s = "("

    # Match anything that starts with the wrong character

    chars = defaultdict(list)

    for item in strings:
        if item != "":
            chars[item[0]].append(item[1:])

    if len(chars) == 0:
        s += match_end
    else:
        s += chars_to_inverted_class(chars)

    # Now match anything that starts with the right char, but then goes wrong

    for char, sub in chars.items():
        s += "|(" + re.escape(char) + strings_to_inverted_regex(sub) + ")"

    s += ")"
    return s

if __name__ == "__main__":
    stdin_lines = []
    for line in sys.stdin:
        if line.strip() != "":
            stdin_lines.append(line.strip())

    print("^" + strings_to_inverted_regex(stdin_lines))

# Test:
# (echo foo; echo fo/; echo foo/; echo foo/ba/r; echo b; echo az; echo az/; echo az/a; echo ab; echo ab/a; echo ab/; echo abc; echo abcde; echo abb; echo ac; echo b) | grep -vE "$((echo ab; echo az; echo foo;) | python includes-to-excludes.py | tee /dev/stderr )"
# should print ab, az, foo and their subpaths
