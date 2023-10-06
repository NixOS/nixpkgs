#!/usr/bin/env nix-shell
#! nix-shell -i "python3 -I" -p "python3.withPackages(p: with p; [ rich structlog ])"

from abc import ABC, abstractclassmethod, abstractmethod
from contextlib import contextmanager
from pathlib import Path
from structlog.contextvars import bound_contextvars as log_context
from typing import ClassVar, List, Tuple

import hashlib, re, structlog


logger = structlog.getLogger("sha-to-SRI")


class Encoding(ABC):
    alphabet: ClassVar[str]

    @classmethod
    @property
    def name(cls) -> str:
        return cls.__name__.lower()

    def toSRI(self, s: str) -> str:
        digest = self.decode(s)
        assert len(digest) == self.n

        from base64 import b64encode
        return f"{self.hashName}-{b64encode(digest).decode()}"

    @classmethod
    def all(cls, h) -> 'List[Encoding]':
        return [ c(h) for c in cls.__subclasses__() ]

    def __init__(self, h):
        self.n = h.digest_size
        self.hashName = h.name

    @property
    @abstractmethod
    def length(self) -> int:
        ...

    @property
    def regex(self) -> str:
        return f"[{self.alphabet}]{{{self.length}}}"

    @abstractmethod
    def decode(self, s: str) -> bytes:
        ...


class Nix32(Encoding):
    alphabet = "0123456789abcdfghijklmnpqrsvwxyz"
    inverted  = { c: i for i, c in enumerate(alphabet) }

    @property
    def length(self):
        return 1 + (8 * self.n) // 5
    def decode(self, s: str):
        assert len(s) == self.length
        out = [ 0 for _ in range(self.n) ]
        # TODO: Do better than a list of byte-sized ints

        for n, c in enumerate(reversed(s)):
            digit = self.inverted[c]
            i, j = divmod(5 * n, 8)
            out[i] = out[i] | (digit << j) & 0xff
            rem = digit >> (8 - j)
            if rem == 0:
                continue
            elif i < self.n:
                out[i+1] = rem
            else:
                raise ValueError(f"Invalid nix32 hash: '{s}'")

        return bytes(out)

class Hex(Encoding):
    alphabet = "0-9A-Fa-f"

    @property
    def length(self):
        return 2 * self.n
    def decode(self, s: str):
        from binascii import unhexlify
        return unhexlify(s)

class Base64(Encoding):
    alphabet = "A-Za-z0-9+/"

    @property
    def format(self) -> Tuple[int, int]:
        """Number of characters in data and padding."""
        i, k = divmod(self.n, 3)
        return 4 * i + (0 if k == 0 else k + 1), (3 - k) % 3
    @property
    def length(self):
        return sum(self.format)
    @property
    def regex(self):
        data, padding = self.format
        return f"[{self.alphabet}]{{{data}}}={{{padding}}}"
    def decode(self, s):
        from base64 import b64decode
        return b64decode(s, validate = True)


_HASHES = (hashlib.new(n) for n in ('SHA-256', 'SHA-512'))
ENCODINGS = {
    h.name: Encoding.all(h)
    for h in _HASHES
}

RE = {
    h: "|".join(
        (f"({h}-)?" if e.name == 'base64' else '') +
        f"(?P<{h}_{e.name}>{e.regex})"
        for e in encodings
    ) for h, encodings in ENCODINGS.items()
}

_DEF_RE = re.compile("|".join(
    f"(?P<{h}>{h} = (?P<{h}_quote>['\"])({re})(?P={h}_quote);)"
    for h, re in RE.items()
))


def defToSRI(s: str) -> str:
    def f(m: re.Match[str]) -> str:
        try:
            for h, encodings in ENCODINGS.items():
                if m.group(h) is None:
                    continue

                for e in encodings:
                    s = m.group(f"{h}_{e.name}")
                    if s is not None:
                        return f'hash = "{e.toSRI(s)}";'

                raise ValueError(f"Match with '{h}' but no subgroup")
            raise ValueError("Match with no hash")

        except ValueError as exn:
            logger.error(
                "Skipping",
                exc_info = exn,
            )
            return m.group()

    return _DEF_RE.sub(f, s)


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


_SKIP_RE = re.compile(
    "(generated by)|(do not edit)",
    re.IGNORECASE
)

if __name__ == "__main__":
    from sys import argv, stderr
    logger.info("Starting!")

    for arg in argv[1:]:
        p = Path(arg)
        with log_context(path=str(p)):
            try:
                if p.name == "yarn.nix" or p.name.find("generated") != -1:
                    logger.warning("File looks autogenerated, skipping!")
                    continue

                with p.open() as f:
                    for line in f:
                        if line.strip():
                            break

                    if _SKIP_RE.search(line):
                        logger.warning("File looks autogenerated, skipping!")
                        continue

                fileToSRI(p)
            except Exception as exn:
                logger.error(
                    "Unhandled exception, skipping file!",
                    exc_info = exn,
                )
            else:
                logger.info("Finished processing file")
