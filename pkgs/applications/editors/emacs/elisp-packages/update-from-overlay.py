#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p nix git

import argparse
import contextlib
import dataclasses
import datetime
import logging
import os
import pathlib
import shutil
import subprocess
import urllib.request

@dataclasses.dataclass
class EmacsOverlay:
    git_url = f'https://github.com/nix-community/emacs-overlay'
    raw_url = f'https://raw.githubusercontent.com/nix-community/emacs-overlay'
    elisp_packages_set = {
        'elpa': {
            'location': 'repos/elpa',
            'basename': 'elpa-generated.nix',
            'nix_attrs': ['elpaPackages']
        },
        'elpa-devel': {
            'location': 'repos/elpa',
            'basename': 'elpa-devel-generated.nix',
            'nix_attrs': ['elpaDevelPackages']
        },
        'melpa': {
            'location': 'repos/melpa',
            'basename': 'recipes-archive-melpa.json',
            'nix_attrs': ['melpaPackages',
                          'melpaStablePackages']
        },
        'nongnu': {
            'location': 'repos/nongnu',
            'basename': 'nongnu-generated.nix',
            'nix_attrs': ['nongnuPackages']
        },
        'nongnu-devel': {
            'location': 'repos/nongnu',
            'basename': 'nongnu-devel-generated.nix',
            'nix_attrs': ['nongnuDevelPackages']
        },
    }

    def master_sha (self):
        """Return the SHA of current master tip."""
        cmdline = ['git', 'ls-remote', '--branches', self.git_url, 'refs/heads/master']
        result = subprocess.run(cmdline, capture_output = True, text = True)
        return result.stdout.split()[0]


@dataclasses.dataclass
class HereDirectory:
    path = pathlib.Path('.').resolve()

    def git_root(self):
        cmdline = ['git', 'rev-parse', '--show-toplevel']
        result = subprocess.run(cmdline, capture_output = True, text = True)

        return pathlib.Path(result.stdout.rstrip()).resolve()

def fetch_fileset (name, sha,
                   emacs_overlay, here_directory, log):
    """Fetch a fileset from emacs overlay.

    Arguments:
    name -- The name of fileset.
    sha -- The commit SHA of emacs-overlay from which the files are retrieved.
    """
    log.debug('BEGIN')

    location = emacs_overlay.elisp_packages_set[name]['location']
    basename = emacs_overlay.elisp_packages_set[name]['basename']
    url = f'{emacs_overlay.raw_url}/{sha}/{location}/{basename}'

    destination = pathlib.Path(here_directory.path, basename).resolve()

    log.debug(f'Getting {url}')

    with urllib.request.urlopen (url) as input_stream, open(destination, 'wb') as output_file:
        log.info(f'Installing {destination}')
        shutil.copyfileobj(input_stream, output_file)

    log.debug('END')

def check_fileset (name,
                   emacs_overlay, here_directory, log):
    """Smoke-tests the fileset.

    Arguments:
    name -- The name of fileset.
    """
    log.debug('BEGIN')

    for nix_attr in emacs_overlay.elisp_packages_set[name]['nix_attrs']:

        cmdline = ['nix-instaniate', '--show-trace', here_directory.git_root(),
                   '-A', f'emacsPackages.{nix_attr}']
        environment = os.environ
        environment['NIXPKGS_ALLOW_BROKEN'] = '1'

        log.info(f'Testing {nix_attr}')
        # TODO: capture the output (to put it in the logfile).
        result = subprocess.run(cmdline, capture_output = True, text = True)
        log.debug(f'''
Shell Command: {result.args}
Output:
{result.stdout}''')

    log.debug('END')

def commit_fileset (name, sha, datestring,
                    emacs_overlay, here_directory, log):
    """Commits the fileset.

    Arguments:
    name -- The name of fileset.
    sha -- The commit SHA of emacs-overlay from which the files are retrieved.
    datestring -- The date to be written on commit message. If None, use the current time.
    """
    log.debug('BEGIN')

    nix_attrs = emacs_overlay.elisp_packages_set[name]['nix_attrs']
    basename = emacs_overlay.elisp_packages_set[name]['basename']

    if datestring == None:
        datestring = datetime.datetime.today().strftime('%Y-%m-%d')
        log.debug(f'Date string not provided, using {datestring}')
    else:
        log.debug(f'Date string was provided: {datestring}')

    cmdline_verify = ['git', 'diff', '--exit-code', '--quiet', '--', basename]
    result_verify = subprocess.run(cmdline_verify)

    if result_verify.returncode != 0:
        attrs = ', '.join(nix_attrs)
        commit_message = f'''{attrs}: Updated at {datestring} (from emacs-overlay)

emacs-overlay commit: {sha}
'''
        cmdline_commit = ['git', 'commit', '--message', commit_message, '--', basename]
        result_commit = subprocess.run(cmdline_commit, capture_output = True, text = True)
        log.info(f'File {basename} committed')
        log.debug(f'''
Shell Command: {result_commit.args}
Output:
{result_commit.stdout}''')
    else:
        log.info(f'File {basename} not modified, skipping')

    log.debug('END')

def main (emacs_overlay, here_directory):
    """The entry point."""
    parser = argparse.ArgumentParser(
        description = 'Fetch and commit Elisp package sets from nix-community/emacs-overlay',
    )
    parser.add_argument(
        '--commit',
        help = 'Commit to be fetched, in SHA format. If not specified, retrieve the master tip.',
        default = None
    )
    parser.add_argument(
        '--loglevel',
        help = 'Level of noisiness of logging messages. Values currently supported: INFO (default), DEBUG.',
        default = "InFo"
    )
    args = parser.parse_args()
    if args.commit == None:
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

    # TODO: Support redirect logging to a user-provided file.
    logging.basicConfig(
        level=loglevel,
        format='%(asctime)s - %(levelname)s - %(funcName)s - %(message)s',
        datefmt='[%Y-%m-%d %H:%M:%S]'
    )
    log = logging.getLogger('update-from-overlay')

    datestring = datetime.datetime.today().strftime('%Y-%m-%d')

    # The loops are decoupled because each phase interferes with the next ones;
    # e.g. it is pretty possible that an Elisp package updated in fetch_fileset
    # breaks the check because of another Elisp package.
    for name in emacs_overlay.elisp_packages_set:
        fetch_fileset(name, sha,
                      emacs_overlay = emacs_overlay,
                      here_directory = here_directory,
                      log = log)

    for name in emacs_overlay.elisp_packages_set:
        check_fileset(name,
                      emacs_overlay = emacs_overlay,
                      here_directory = here_directory,
                      log = log)

    for name in emacs_overlay.elisp_packages_set:
        commit_fileset(name, sha, datestring = datestring,
                       emacs_overlay = emacs_overlay,
                       here_directory = here_directory,
                       log = log)

if __name__ == '__main__':
    emacs_overlay = EmacsOverlay()
    here_directory = HereDirectory()
    with contextlib.chdir(here_directory.path):
        main(emacs_overlay = emacs_overlay,
             here_directory = here_directory)
