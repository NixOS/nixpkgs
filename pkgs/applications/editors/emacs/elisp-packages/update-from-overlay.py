#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p nix git

# linter: ruff check update-from-overlay.py
# formatter: ruff format update-from-overlay.py
# type-checker: mypy update-from-overlay.py

import argparse
import contextlib
import dataclasses
import datetime
import logging
import os
import pathlib
import shutil
import subprocess
import sys
import urllib.request


@dataclasses.dataclass
class EmacsOverlay:
    git_url: str = "https://github.com/nix-community/emacs-overlay"
    raw_url: str = "https://raw.githubusercontent.com/nix-community/emacs-overlay"
    # The field declaration here is a hack around the error:
    # ValueError: mutable default <class 'dict'> for field elisp_packages_set is not allowed: use default_factory
    # See more at https://peps.python.org/pep-0557/#mutable-default-values
    elisp_packages_set: dict[str, dict] = dataclasses.field(
        default_factory=lambda: {
            "elpa": {
                "location": "repos/elpa",
                "basename": "elpa-generated.nix",
                "nix_attrs": ["elpaPackages"],
            },
            "elpa-devel": {
                "location": "repos/elpa",
                "basename": "elpa-devel-generated.nix",
                "nix_attrs": ["elpaDevelPackages"],
            },
            "melpa": {
                "location": "repos/melpa",
                "basename": "recipes-archive-melpa.json",
                "nix_attrs": ["melpaPackages", "melpaStablePackages"],
            },
            "nongnu": {
                "location": "repos/nongnu",
                "basename": "nongnu-generated.nix",
                "nix_attrs": ["nongnuPackages"],
            },
            "nongnu-devel": {
                "location": "repos/nongnu",
                "basename": "nongnu-devel-generated.nix",
                "nix_attrs": ["nongnuDevelPackages"],
            },
        }
    )

    def master_sha(self) -> str:
        """Return the SHA of current master tip."""
        cmdline = ["git", "ls-remote", "--branches", self.git_url, "refs/heads/master"]
        result = subprocess.run(cmdline, capture_output=True, text=True, check=True)
        return result.stdout.split()[0]


@dataclasses.dataclass
class HereDirectory:
    path: pathlib.Path = pathlib.Path(".").resolve()

    def git_root(self) -> pathlib.Path:
        """Returns the root directory of Git repository."""
        cmdline = ["git", "rev-parse", "--show-toplevel"]
        result = subprocess.run(cmdline, capture_output=True, text=True, check=True)

        return pathlib.Path(result.stdout.rstrip()).resolve()


def main(
    emacs_overlay: EmacsOverlay,
    here_directory: HereDirectory,
    argument_parser: argparse.ArgumentParser,
) -> None:
    """The entry point."""

    args = argument_parser.parse_args()

    if args.commit is None:
        sha = emacs_overlay.master_sha()
    else:
        sha = args.commit

    match args.loglevel.lower():
        case "debug":
            loglevel = logging.DEBUG
        case "info":
            loglevel = logging.INFO
        case _:
            loglevel = logging.INFO

    logger = get_logger(loglevel=loglevel)

    datestring = datetime.datetime.today().strftime("%Y-%m-%d")

    # The loops are decoupled because each phase interferes with the next ones;
    # e.g. it is pretty possible that an Elisp package updated in fetch_fileset
    # breaks the check because of another Elisp package.
    for name in emacs_overlay.elisp_packages_set:
        fetch_fileset(
            name,
            sha,
            emacs_overlay=emacs_overlay,
            here_directory=here_directory,
            logger=logger,
        )

    for name in emacs_overlay.elisp_packages_set:
        check_fileset(
            name,
            emacs_overlay=emacs_overlay,
            here_directory=here_directory,
            logger=logger,
        )

    for name in emacs_overlay.elisp_packages_set:
        commit_fileset(
            name,
            sha,
            datestring=datestring,
            emacs_overlay=emacs_overlay,
            here_directory=here_directory,
            logger=logger,
        )


def get_argument_parser() -> argparse.ArgumentParser:
    """Return a getopt-style parser for command-line arguments."""
    parser = argparse.ArgumentParser(
        description="Fetch and commit Elisp package sets from nix-community/emacs-overlay",
    )
    parser.add_argument(
        "--commit",
        help="Commit to be fetched, in SHA format. If not specified, retrieve the master tip.",
        default=None,
    )
    parser.add_argument(
        "--loglevel",
        help="Level of noisiness of logging messages. Values currently supported: INFO (default), DEBUG.",
        default="InFo",
    )

    return parser


def get_logger(loglevel: int) -> logging.Logger:
    """Return a basic logging facility to emit messages over console (stdout)."""
    logger = logging.getLogger("update-from-overlay")
    # Set the lowest level here, so that it does not clobber the one provided by
    # the function argument
    logger.setLevel(logging.DEBUG)

    console_formatter = logging.Formatter(
        fmt="%(asctime)s - %(levelname)s - %(funcName)s - %(message)s",
        datefmt="[%Y-%m-%d %H:%M:%S]",
    )

    console_handler = logging.StreamHandler(stream=sys.stdout)
    console_handler.setLevel(loglevel)
    console_handler.setFormatter(console_formatter)

    logger.addHandler(console_handler)

    return logger


def fetch_fileset(
    name: str,
    sha: str,
    emacs_overlay: EmacsOverlay,
    here_directory: HereDirectory,
    logger: logging.Logger,
) -> None:
    """Fetch a fileset from emacs overlay.

    Arguments:
    name -- The name of fileset.
    sha -- The commit SHA of emacs-overlay from which the files are retrieved.
    """
    logger.debug("BEGIN")

    location = emacs_overlay.elisp_packages_set[name]["location"]
    basename = emacs_overlay.elisp_packages_set[name]["basename"]
    url = f"{emacs_overlay.raw_url}/{sha}/{location}/{basename}"

    destination = pathlib.Path(here_directory.path, basename).resolve()

    logger.debug(f"Getting {url}")

    with (
        urllib.request.urlopen(url) as input_stream,
        open(destination, "wb") as output_file,
    ):
        logger.info(f"Installing {destination}")
        shutil.copyfileobj(input_stream, output_file)

    logger.debug("END")


def check_fileset(
    name: str,
    emacs_overlay: EmacsOverlay,
    here_directory: HereDirectory,
    logger: logging.Logger,
) -> None:
    """Smoke-test the fileset.

    Arguments:
    name -- The name of fileset.
    """
    logger.debug("BEGIN")

    for nix_attr in emacs_overlay.elisp_packages_set[name]["nix_attrs"]:
        cmdline = [
            "nix-instantiate",
            "--show-trace",
            str(here_directory.git_root()),
            "-A",
            f"emacsPackages.{nix_attr}",
        ]
        environment = os.environ
        environment["NIXPKGS_ALLOW_BROKEN"] = "1"

        logger.info(f"Testing {nix_attr}")
        # TODO: capture the output (to put it in the logfile).
        result = subprocess.run(cmdline, capture_output=True, text=True, check=True)
        logger.debug(f"""
Shell Command: {result.args}
Output:
{result.stdout}""")

    logger.debug("END")


def commit_fileset(
    name: str,
    sha: str,
    datestring: str | None,
    emacs_overlay: EmacsOverlay,
    here_directory: HereDirectory,
    logger: logging.Logger,
) -> None:
    """Commit the fileset.

    Arguments:
    name -- The name of fileset.
    sha -- The commit SHA of emacs-overlay from which the files are retrieved.
    datestring -- The date to be written on commit message. If None, use the current time.
    """
    logger.debug("BEGIN")

    nix_attrs = emacs_overlay.elisp_packages_set[name]["nix_attrs"]
    basename = emacs_overlay.elisp_packages_set[name]["basename"]

    if datestring is None:
        datestring = datetime.datetime.today().strftime("%Y-%m-%d")
        logger.debug(f"Date string not provided, using {datestring}")
    else:
        logger.debug(f"Date string was provided: {datestring}")

    cmdline_verify = ["git", "diff", "--exit-code", "--quiet", "--", basename]
    result_verify = subprocess.run(cmdline_verify)

    if result_verify.returncode != 0:
        attrs = ", ".join(nix_attrs)
        commit_message = f"""{attrs}: Updated at {datestring} (from emacs-overlay)

emacs-overlay commit: {sha}
"""
        cmdline_commit = ["git", "commit", "--message", commit_message, "--", basename]
        result_commit = subprocess.run(
            cmdline_commit, capture_output=True, text=True, check=True
        )
        logger.info(f"File {basename} committed")
        logger.debug(f"""
Shell Command: {result_commit.args}
Output:
{result_commit.stdout}""")
    else:
        logger.info(f"File {basename} not modified, skipping")

    logger.debug("END")


if __name__ == "__main__":
    emacs_overlay = EmacsOverlay()
    here_directory = HereDirectory()
    argument_parser = get_argument_parser()
    with contextlib.chdir(here_directory.path):
        main(
            emacs_overlay=emacs_overlay,
            here_directory=here_directory,
            argument_parser=argument_parser,
        )
