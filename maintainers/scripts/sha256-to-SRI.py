#!/usr/bin/env nix-shell
#! nix-shell -i "python3 -I" -p python3

from contextlib import contextmanager
from pathlib import Path

import re


alphabet = "0123456789abcdfghijklmnpqrsvwxyz"
inverted_alphabet = { c: i for i, c in enumerate(alphabet) }


def decode(s: str) -> bytes:
    # only support sha256 hashes for now
    assert len(s) == 52
    out = [ 0 for _ in range(32) ]
    # TODO: Do better than a list of byte-sized ints

    for n, c in enumerate(reversed(s)):
        digit = inverted_alphabet[c]
        i, j = divmod(5 * n, 8)
        out[i] = out[i] | (digit << j) & 0xff
        rem = digit >> (8 - j)
        if rem == 0:
            continue
        elif i < 31:
            out[i+1] = rem
        else:
            raise ValueError(f"Invalid nix32 hash: '{s}'")

    return bytes(out)


def toSRI(s: str) -> str:
    from base64 import b64encode

    digest = decode(s)
    assert(len(digest) == 32)
    return f"sha256-{b64encode(digest).decode()}"


RE = f"[{alphabet}]" "{52}";
# Ohno I used evil, irregular backrefs  ^^'
_sha256_re = re.compile(f'sha256 = (?P<quote>["\'])(?P<nix32>{RE})(?P=quote);')

def defToSRI(s: str) -> str:
    return _sha256_re.sub(
        lambda m: f'hash = "{toSRI(m["nix32"])}";',
        s,
    )


@contextmanager
def atomicFileUpdate(target: Path):
    '''Atomically replace the contents of a file.

    Guarantees that no temporary files are left behind, and `target` is either
    left untouched, or overwritten with new content if no exception was raised.

    Yields a pair `(original, new)` of open files.
    `original` is the pre-existing file at `target`, open for reading;
    `new` is an empty, temporary file in the same filder, open for writing.

    Upon exiting the context, the files are closed; if no exception was
    raised, `new` (atomically) replaces the `target`, otherwise it is deleted.
    '''
    # That's mostly copied from noto-emoji.py, should DRY it out
    from tempfile import mkstemp
    fd, _p = mkstemp(
        dir = target.parent,
        prefix = target.name,
    )
    tmpPath = Path(_p)

    try:
        with target.open() as original:
            with tmpPath.open('w') as new:
                yield (original, new)

        tmpPath.replace(target)

    except Exception:
        tmpPath.unlink(missing_ok = True)
        raise


def fileToSRI(p: Path):
    with atomicFileUpdate(p) as (og, new):
        for line in og:
            new.write(defToSRI(line))


if __name__ == "__main__":
    from sys import argv, stderr

    for arg in argv[1:]:
        p = Path(arg)
        if not p.is_file():
            print(f"Argument '{arg}' is not a regular file's path", file=stderr)
        else:
            print(f"Processing '{arg}'")
            fileToSRI(p)
