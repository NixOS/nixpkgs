#! /usr/bin/env nix-shell
#! nix-shell -i "python3 -I" -p "python3.withPackages(p: with p; [ aiohttp rich structlog ])"

from argparse import ArgumentParser, Namespace
from collections import defaultdict
from collections.abc import Mapping, Sequence
from enum import IntEnum
from http import HTTPStatus
from pathlib import Path
from typing import Optional
import asyncio, json, logging

import aiohttp, structlog
from structlog.contextvars import bound_contextvars as log_context


LogLevel = IntEnum('LogLevel', {
    lvl: getattr(logging, lvl)
    for lvl in ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')
})
LogLevel.__str__ = lambda self: self.name


EXPECTED_STATUS=frozenset((
    HTTPStatus.OK, HTTPStatus.FOUND,
    HTTPStatus.NOT_FOUND,
))

async def check(session: aiohttp.ClientSession, manpage: str, url: str) -> HTTPStatus:
    with log_context(manpage=manpage, url=url):
        logger.debug("Checking")
        async with session.head(url) as resp:
            st = HTTPStatus(resp.status)
            match st:
                case HTTPStatus.OK | HTTPStatus.FOUND:
                    logger.debug("OK!")
                case HTTPStatus.NOT_FOUND:
                    logger.error("Broken link!")
                case _ if st < 400:
                    logger.info("Unexpected code", status=st)
                case _ if 400 <= st < 600:
                    logger.warn("Unexpected error", status=st)

            return st

async def main(urls_path: Path) -> Mapping[HTTPStatus, int]:
    logger.info(f"Parsing {urls_path}")
    with urls_path.open() as urls_file:
        urls = json.load(urls_file)

    count: defaultdict[HTTPStatus, int] = defaultdict(lambda: 0)

    logger.info(f"Checking URLs from {urls_path}")
    async with aiohttp.ClientSession() as session:
        for status in asyncio.as_completed([
            check(session, manpage, url)
            for manpage, url in urls.items()
        ]):
            count[await status]+=1

    ok = count[HTTPStatus.OK] + count[HTTPStatus.FOUND]
    broken = count[HTTPStatus.NOT_FOUND]
    unknown = sum(c for st, c in count.items() if st not in EXPECTED_STATUS)
    logger.info(f"Done: {broken} broken links, "
                f"{ok} correct links, and {unknown} unexpected status")

    return count


def parse_args(args: Optional[Sequence[str]] = None) -> Namespace:
    parser = ArgumentParser(
        prog = 'check-manpage-urls',
        description = 'Check the validity of the manpage URLs linked in the nixpkgs manual',
    )
    parser.add_argument(
        '-l', '--log-level',
        default = os.getenv('LOG_LEVEL', 'INFO'),
        type = lambda s: LogLevel[s],
        choices = list(LogLevel),
    )
    parser.add_argument(
        'file',
        type = Path,
        nargs = '?',
    )

    return parser.parse_args(args)


if __name__ == "__main__":
    import os, sys

    args = parse_args()

    structlog.configure(
        wrapper_class=structlog.make_filtering_bound_logger(args.log_level),
    )
    logger = structlog.getLogger("check-manpage-urls.py")

    urls_path = args.file
    if urls_path is None:
        REPO_ROOT = Path(__file__).parent.parent.parent.parent
        logger.info(f"Assuming we are in a nixpkgs repo rooted at {REPO_ROOT}")

        urls_path = REPO_ROOT / 'doc' / 'manpage-urls.json'

    count = asyncio.run(main(urls_path))

    sys.exit(0 if count[HTTPStatus.NOT_FOUND] == 0 else 1)
