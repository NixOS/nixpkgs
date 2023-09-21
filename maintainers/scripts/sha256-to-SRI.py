#!/usr/bin/env nix-shell
#! nix-shell -i "python3 -I" -p "python3.withPackages(p: with p; [ rich structlog ])"

from contextlib import contextmanager
from pathlib import Path
from structlog.contextvars import bound_contextvars as log_context

import re, structlog


logger = structlog.getLogger("sha256-to-SRI")


nix32alphabet = "0123456789abcdfghijklmnpqrsvwxyz"
nix32inverted  = { c: i for i, c in enumerate(nix32alphabet) }

def nix32decode(s: str) -> bytes:
    # only support sha256 hashes for now
    assert len(s) == 52
    out = [ 0 for _ in range(32) ]
    # TODO: Do better than a list of byte-sized ints

    for n, c in enumerate(reversed(s)):
        digit = nix32inverted[c]
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


def toSRI(digest: bytes) -> str:
    from base64 import b64encode
    assert len(digest) == 32
    return f"sha256-{b64encode(digest).decode()}"


RE = {
    'nix32': f"[{nix32alphabet}]" "{52}",
    'hex':    "[0-9A-Fa-f]{64}",
    'base64': "[A-Za-z0-9+/]{43}=",
}
RE['sha256'] = '|'.join(
    f"{'(sha256-)?' if name == 'base64' else ''}"
    f"(?P<{name}>{r})"
    for name, r in RE.items()
)

def sha256toSRI(m: re.Match) -> str:
    """Produce the equivalent SRI string for any match of RE['sha256']"""
    if m['nix32'] is not None:
        return toSRI(nix32decode(m['nix32']))
    if m['hex'] is not None:
        from binascii import unhexlify
        return toSRI(unhexlify(m['hex']))
    if m['base64'] is not None:
        from base64 import b64decode
        return toSRI(b64decode(m['base64']))

    raise ValueError("Got a match where none of the groups captured")


# Ohno I used evil, irregular backrefs instead of making 2 variants  ^^'
_def_re = re.compile(
    "sha256 = (?P<quote>[\"'])"
    f"({RE['sha256']})"
    "(?P=quote);"
)

def defToSRI(s: str) -> str:
    def f(m: re.Match[str]) -> str:
        try:
            return f'hash = "{sha256toSRI(m)}";'

        except ValueError as exn:
            begin, end = m.span()
            match = m.string[begin:end]

            logger.error(
                "Skipping",
                exc_info = exn,
            )
            return match

    return _def_re.sub(f, s)


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
        for i, line in enumerate(og):
            with log_context(line=i):
                new.write(defToSRI(line))


if __name__ == "__main__":
    from sys import argv, stderr

    for arg in argv[1:]:
        p = Path(arg)
        with log_context(path=str(p)):
            try:
                fileToSRI(p)
            except Exception as exn:
                logger.error(
                    "Unhandled exception, skipping file!",
                    exc_info = exn,
                )
            else:
                logger.info("Finished processing file")
