#!/usr/bin/env python3.4
"""Update NixOS system configuration from infrastructure or local sources."""

import argparse
import json
import logging
import os
import shutil
import xmlrpc.client


# TODO
#
# - better integration with dev-checkouts, not killing them with the channel
#   version
# - better channel management
#   - explicitly download nixpkgs from our hydra
#   - keep a "current" version
#   - keep the "next" version
#   - validate the next version and decide whether to switch automatically
#     or whether to create a maintenance window and let the current one stay
#     for now, but keep updating ENC data.
#
# - better robustness to not leave non-parsable json files around


enc = None
directory = None


def load_enc():
    global enc, directory
    if not os.path.exists('/etc/nixos/enc.json'):
        if not os.path.exists('/tmp/fc-data/enc.json'):
            # This environment doesn't seem to support an ENC,
            # i.e. Vagrant. Silently ignore for now.
            return
        shutil.copy('/tmp/fc-data/enc.json',
                    '/etc/nixos/enc.json')
    enc = json.load(open('/etc/nixos/enc.json'))
    directory = xmlrpc.client.Server(
        'https://{}:{}@directory.fcio.net/v2/api/rg-{}'.format(
            enc['name'],
            enc['parameters']['directory_password'],
            enc['parameters']['resource_group']))


def system_state():
    def load_system_state():
        result = {}
        try:
            with open('/proc/meminfo') as f:
                for line in f:
                    if line.startswith('MemTotal:'):
                        _, memkb, _ = line.split()
                        result['memory'] = int(memkb) // 1024
                        break
        except IOError:
            pass
        return result

    _load_and_write_json([
        (lambda: load_system_state(),
         'system_state.json'),
    ])


def _load_and_write_json(calls):
    for lookup, target in calls:
        print('Retrieving {} ...'.format(target))
        try:
            data = lookup()
            with open('/etc/nixos/{}'.format(target), 'w') as f:
                os.chmod(f.fileno(), 0o600)
                json.dump(data, f, ensure_ascii=False)
        except Exception:
            logging.exception('Error retrieving data:')


def update_inventory():
    if directory is None:
        print('No directory. Not updating inventory.')
        return
    _load_and_write_json([
        (lambda: directory.lookup_node(enc['name']),
         'enc.json'),
        (lambda: directory.list_users(),
         'users.json'),
        (lambda: directory.list_permissions(),
         'permissions.json'),
        (lambda: directory.lookup_resourcegroup('admins'),
         'admins.json'),
        (lambda: directory.list_services(),
         'services.json'),
        (lambda: directory.list_service_clients(),
         'service_clients.json')
    ])


def build_channel(build_options):
    print('Switching channel ...')
    try:
        os.system(
            'nix-channel --add '
            'https://hydra.flyingcircus.io/channels/branches/{} nixos'.format(
                enc['parameters']['environment']))
        os.system('nix-channel --update')
        os.system('nixos-rebuild --no-build-output switch {}'.format(
                  ' '.join(build_options)))
    except Exception:
        logging.exception('Error switching channel ')


def build_dev(build_options):
    print('Switching to development environment')
    try:
        os.system(
            'nix-channel --remove nixos')
    except Exception:
        logging.exception('Error removing channel ')
    os.system('nixos-rebuild -I nixpkgs=/root/nixpkgs switch {}'.format(
              ' '.join(build_options)))


def main():
    logging.basicConfig()
    build_options = []
    a = argparse.ArgumentParser(description=__doc__)
    a.add_argument('--show-trace', default=False, action='store_true',
                   help='instruct nixos-rebuild to dump tracebacks on failure')
    a.add_argument('-e', '--directory', default=False, action='store_true',
                   help='refresh local ENC copy')
    a.add_argument('-s', '--system-state', default=False, action='store_true',
                   help='dump local system information (like memory size) '
                   'to system_state.json')
    build = a.add_mutually_exclusive_group()
    build.add_argument('-c', '--channel', default=False, dest='build',
                       action='store_const', const='build_channel',
                       help='switch machine to FCIO channel')
    build.add_argument('-d', '--dev', default=False, dest='build',
                       action='store_const', const='build_dev',
                       help='switch machine to local checkout in '
                       '/root/nixpkgs')
    args = a.parse_args()

    if args.show_trace:
        build_options.append('--show-trace')

    if args.directory:
        load_enc()
        update_inventory()

    if args.system_state:
        system_state()

    # reload ENC data in case update_inventory changed something
    load_enc()

    if args.build:
        globals()[args.build](build_options)

    if not args.build and not args.directory and not args.system_state:
        a.error('no action specified')


if __name__ == '__main__':
    main()
