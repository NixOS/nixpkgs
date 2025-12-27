#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p nix git python3packages.pygit2

import argparse
import contextlib
import datetime
import logging
import os
import shutil
import subprocess
import sys
import urllib.request

# External Dependencies:
import pygit2

heredir = os.path.dirname(os.path.realpath(__file__))
r = pygit2.Repository(heredir)
# pygit2 uses workdir (the one with .git) as "root" to deal with files.
relative_heredir = heredir.removeprefix(r.workdir)

# To make this script a bit noisy, let's set a logging hierarchy.
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(name)s - %(message)s',
    datefmt='[%Y-%m-%d %H:%M:%S]'
)
logger = logging.getLogger('update-from-overlay')

# The elements of this dictionary have the following format:
# <package set name> : {
#    'location': <directory from the root of emacs-overlay>
#    'basename': <the base name of the file>
#    'nix_attributes': [<a list of attributes>]
# }
elisp_packages_set = {
    'elpa': {
        'location': 'repos/elpa',
        'basename': 'elpa-generated.nix',
        'nix_attributes': ['emacsPackages.elpaPackages']
    },
    'elpa-devel': {
        'location': 'repos/elpa',
        'basename': 'elpa-devel-generated.nix',
        'nix_attributes': ['emacsPackages.elpaDevelPackages']
    },
    'melpa': {
        'location': 'repos/melpa',
        'basename': 'recipes-archive-melpa.json',
        'nix_attributes': ['emacsPackages.melpaPackages',
                           'emacsPackages.melpaStablePackages']
    },
    'nongnu': {
        'location': 'repos/nongnu',
        'basename': 'nongnu-generated.nix',
        'nix_attributes': ['emacsPackages.nongnuPackages']
    },
    'nongnu-devel': {
        'location': 'repos/nongnu',
        'basename': 'nongnu-devel-generated.nix',
        'nix_attributes': ['emacsPackages.nongnuDevelPackages']
    },
}

gms_logger = logger.getChild('grab_master_sha')
def grab_master_sha ():
    """Return the SHA of current master tip of emacs-overlay."""
    gms_logger.debug('BEGIN')
    cmdline = []
    cmdline += [ 'git' ]
    cmdline += [ 'ls-remote', '--branches' ]
    cmdline += [ 'https://github.com/nix-community/emacs-overlay.git' ]
    cmdline += [ 'refs/heads/master' ]

    if shutil.which('git'):
        gms_logger.debug('Grabbing SHA from master tip')
        result = subprocess.run(cmdline, capture_output = True, text = True)
        sha = result.stdout.split()[0]
    else:
        gms_logger.warning('git command not found')
        sha = None
    gms_logger.debug(f'SHA = {sha}')
    gms_logger.debug('END')
    return sha

ff_logger = logger.getChild('fetch_fileset')
def fetch_fileset (name, sha):
    """Fetch a fileset from emacs-overlay.

    Arguments:
    name -- The name of fileset, as in elisp_packages_set.
    sha -- The commit SHA of emacs-overlay from which the files are retrieved.
    """
    ff_logger.debug('BEGIN')
    location = elisp_packages_set[name]['location']
    basename = elisp_packages_set[name]['basename']
    url = f'https://raw.githubusercontent.com/nix-community/emacs-overlay/{sha}/{location}/{basename}'

    ff_logger.debug(f'Getting {url}')
    tmpfile = urllib.request.urlretrieve(url)[0]
    destination = f'{heredir}/{basename}'
    ff_logger.debug(f'Installing into {destination}')
    shutil.move(tmpfile,destination)
    ff_logger.debug('END')

ckf_logger = logger.getChild('check_fileset')
def check_fileset (name):
    """Smoke-tests the fileset.

    Arguments:
    name -- The name of fileset, as in elisp_packages_set.
    """
    ckf_logger.debug('BEGIN')
    if shutil.which('nix-instantiate'):
        for nix_attr in elisp_packages_set[name]['nix_attributes']:
            cmdline = []
            cmdline += ['nix-instantiate']
            cmdline += ['--show-trace']
            cmdline += [r.workdir]
            cmdline += ['-A', nix_attr]
            environment = os.environ
            environment['NIXPKGS_ALLOW_BROKEN'] = '1'

            ckf_logger.debug(f'Testing {nix_attr}')
            subprocess.run(cmdline, env=environment)
    else:
        ckf_logger.warning(f'nix-instantiate: command not found')
    ckf_logger.debug('END')

cmf_logger = logger.getChild('commit_fileset')
def commit_fileset (name, sha, datestring = None):
    """Commits the fileset.

    Arguments:
    name -- The name of fileset, as in elisp_packages_set.
    sha -- The commit SHA of emacs-overlay from which the files are retrieved.
    datestring -- The date to be written on commit message. If None, use the current time.
    """
    cmf_logger.debug('BEGIN')
    nix_attributes = elisp_packages_set[name]['nix_attributes']
    basename = elisp_packages_set[name]['basename']
    commit_file = f'{relative_heredir}/{basename}'
    if datestring == None:
        datestring = datetime.datetime.today().strftime('%Y-%m-%d')
        cmf_logger.debug(f'Date string not provided, using {datestring}')
    else:
        cmf_logger.debug(f'Date string was provided: {datestring}')
    attrs = ', '.join(nix_attributes)
    message = f'''{attrs}: Updated at {datestring} (from nix-community/emacs-overlay)

Commit: {sha}
File: {commit_file}
'''
    ref = r.head.name
    author = r.default_signature
    commiter = r.default_signature
    parents = [r.head.target]
    # If commit_file is not modified, the commit becomes empty.
    # Avoid this by verifying the file first.
    if r.status_file(commit_file) == pygit2.enums.FileStatus.WT_MODIFIED:
        cmf_logger.debug(f'File {commit_file} modified, committing')
        r.index.add(commit_file)
        r.index.write()
        tree = r.index.write_tree()
        cmf_logger.debug(f'''Commit message:
{message}
''')
        r.create_commit(ref, author, commiter, message, tree, parents)
    else:
        cmf_logger.debug(f'File {commit_file} not modified, skipping')
    cmf_logger.debug('END')

def main (argv = sys.argv):
    """The entry point.

    Arguments:
    argv -- The argument list; default sys.argv.
    """
    parser = argparse.ArgumentParser(
        prog = argv[0],
        description = 'Fetch and commit Elisp package sets from nix-community/emacs-overlay',
        epilog = 'NixOS/Nixpkgs'
    )
    parser.add_argument(
        '--commit',
        help = 'Commit to be fetched, in SHA format. If not specified, retrieve the master tip.',
        default = None
    )
    args = parser.parse_args()
    if args.commit == None:
        sha = grab_master_sha()
    else:
        sha = args.commit
    datestring = datetime.datetime.today().strftime('%Y-%m-%d')
    for name in elisp_packages_set:
        fetch_fileset(name, sha)
        check_fileset(name)
        commit_fileset(name, sha, datestring)

if __name__ == '__main__':
    with contextlib.chdir(heredir):
        main()
