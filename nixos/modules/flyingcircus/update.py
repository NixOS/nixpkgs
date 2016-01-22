#!/usr/bin/env python3.4
import json
import logging
import os
import shutil
import xmlrpc.client

enc = None
directory = None


def load_enc():
    global enc, directory
    if not os.path.exists('/etc/nixos/enc.json'):
        shutil.copy('/tmp/fc-data/enc.json',
                    '/etc/nixos/enc.json')
    enc = json.load(open('/etc/nixos/enc.json'))
    directory = xmlrpc.client.Server(
        'https://{}:{}@directory.fcio.net/v2/api/rg-{}'.format(
            enc['name'],
            enc['parameters']['directory_password'],
            enc['parameters']['resource_group']))


def update_inventory():
    calls = [
        (lambda: directory.lookup_node(enc['name']),
         'enc.json'),
        (lambda: directory.list_users(),
         'users.json'),
        (lambda: directory.list_permissions(),
         'permissions.json'),
        (lambda: directory.lookup_resourcegroup('admins'),
         'admins.json'),
    ]
    for lookup, target in calls:
        print('Retrieving {} ...'.format(target))
        try:
            data = lookup()
        except Exception:
            logging.exception('Error retrieving data:')
        with open('/etc/nixos/{}'.format(target), 'w') as f:
            json.dump(data, f, ensure_ascii=False)


def ensure_channel():
    print('Switching channel ...')
    try:
        os.system(
            'nix-channel --add '
            'https://hydra.flyingcircus.io/channels/branches/{} nixos'.format(
                enc['parameters']['environment']))
    except Exception:
        logging.exception('Error switching channel ')


def build_system():
    print('Building configuration ...')
    os.system('nixos-rebuild switch --upgrade')


logging.basicConfig()

load_enc()
update_inventory()
load_enc()
ensure_channel()
build_system()
