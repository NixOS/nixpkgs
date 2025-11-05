import argparse
from typing import NoReturn


def print_help(parser: argparse.ArgumentParser) -> NoReturn:
    parser.print_help()
    parser.exit()
