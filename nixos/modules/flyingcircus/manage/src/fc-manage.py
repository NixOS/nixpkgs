#!/usr/bin/env python3.4
import json
import logging
import os
import shutil
import xmlrpc.client
import sys


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
                json.dump(data, f, ensure_ascii=False)
        except Exception:
            logging.exception('Error retrieving data:')


def update_inventory():
    _load_and_write_json([
        (lambda: directory.lookup_node(enc['name']),
         'enc.json'),
        (lambda: directory.list_users(),
         'users.json'),
        (lambda: directory.list_permissions(),
         'permissions.json'),
        (lambda: directory.lookup_resourcegroup('admins'),
         'admins.json'),
    ])


def build_channel():
    print('Switching channel ...')
    try:
        os.system(
            'nix-channel --add '
            'https://hydra.flyingcircus.io/channels/branches/{} nixos'.format(
                enc['parameters']['environment']))
        os.system('nix-channel --update')
        os.system('nixos-rebuild --no-build-output switch')
    except Exception:
        logging.exception('Error switching channel ')


def build_dev():
    print('Switching to development environment')
    try:
        os.system(
            'nix-channel --remove nixos')
    except Exception:
        logging.exception('Error removing channel ')
    os.system('nixos-rebuild -I nixpkgs=/root/nixpkgs switch')


logging.basicConfig()


if '--directory' in sys.argv:
    load_enc()
    update_inventory()

if '--system-state' in sys.argv:
    system_state()

load_enc()

if '--channel' in sys.argv:
    build_channel()

if '--dev' in sys.argv:
    build_dev()
