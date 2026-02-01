#!/usr/bin/env nix-shell
#! nix-shell ./emacs-update-bundle.nix -i python3

import argparse
import contextlib
import dataclasses
import datetime
import logging
import os
import pathlib
import subprocess

# Merge all update-* scripts in one huge Python one!

emacs2nix = os.getenv("EMACS2NIX")

@dataclasses.dataclass
class HereDirectory:
    path = pathlib.Path('.').resolve()

@dataclasses.dataclass
class ElispGenerator:
    elisp_package_sets = {
        'elpa': {
            'generate': ['elpa-packages.sh',
                         '--names', f'{emacs2nix}/names.nix',
                         '-o', 'elpa-generated.nix'],
            'fmt': ['nixfmt', 'elpa-generated.nix'],
        },
        'elpa-devel': {
            'generate': ['elpa-devel-packages.sh', 
                         '--names', f'{emacs2nix}/names.nix', 
                         '-o', 'elpa-devel-generated.nix'],
            'fmt': ['nixfmt', 'elpa-devel-generated.nix'],
        },
        'nongnu': {
            'generate': ['nongnu-packages.sh', 
                         '--names', f'{emacs2nix}/names.nix', 
                         '-o', 'nongnu-generated.nix'],
            'fmt': ['nixfmt', 'nongnu-generated.nix'],
        },
        'nongnu-devel': {
            'generate': ['nongnu-devel-packages.sh', 
                         '--names', f'{emacs2nix}/names.nix', 
                         '-o', 'nongnu-devel-generated.nix'],
            'fmt': ['nixfmt', 'nongnu-devel-generated.nix'],
        },
        'melpa': {
            'generate': ['emacs', '--fg-daemon=updater', '--quick',
                         '-l', f'{heredir}/update-melpa.el',
                         '-f', 'run-updater'],
            'fmt': ['true'],
        },
        'dummy': {
            'generate': ['echo', 'DUMMY-UPDATE'],
            'fmt': ['echo', 'DUMMY-ECHO'],
        }
    }

    def generate(self, package_set, logger):
        result = subprocess.run(self.elisp_package_sets[pkgset]['generate'],
                                capture_output=True, text=True)

    def fmt(self, package_set, logger):
        result = subprocess.run(self.elisp_package_sets[pkgset]['update'],
                                capture_output=True, text=True)
# end ElispGenerator

def main(elisp_generator, here_directory, argument_parser):

    args = argument_parser.parse_args()
    
    match args.loglevel.lower():
        case 'debug':
            loglevel = logging.DEBUG
        case 'info':
            loglevel = logging.INFO
        case _:
            loglevel = logging.INFO

    pass

def get_argument_parser():
    '''Returns a getopt-style parser for command-line arguments.'''
    parser = argparse.ArgumentParser(
        description = 'Generate Elisp package sets locally via nix-community/emacs2nix scripts.',
    )
    parser.add_argument(
        '--packagesets',
        help = f'Package set to be generated. Accepted values: all, any of f{", ".join(list(elisp_package_sets.keys()))}',
        nargs='?',
        default = 'all'
    )
    parser.add_argument(
        '--loglevel',
        help = 'Level of noisiness of logging messages. Values currently supported: INFO (default), DEBUG.',
        default = 'InFo'
    )

    return parser

def get_logger (loglevel):
    '''Returns a basic logging facility to emit messages over console (stdout).'''
    logger = logging.getLogger('update-from-overlay')
    logger.setLevel(logging.DEBUG) # Set the lowest level here, to not clobber
                                   # the one from argument

    console_formatter = logging.Formatter(fmt='%(asctime)s - %(levelname)s - %(funcName)s - %(message)s',
                                          datefmt='[%Y-%m-%d %H:%M:%S]')

    console_handler = logging.StreamHandler(stream = sys.stdout)
    console_handler.setLevel(loglevel)
    console_handler.setFormatter(console_formatter)

    logger.addHandler(console_handler)

    return logger

if __name__ == '__main__':
    here_directory = HereDirectory()
    argument_parser = get_argument_parser()
    with contextlib.chdir(here_directory.path):
        main(here_directory = here_directory,
             argument_parser = argument_parser)
