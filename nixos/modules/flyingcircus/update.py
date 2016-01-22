#!/usr/bin/env python3.4
import xmlrpc.client
import json
import os

enc = json.load(open('/tmp/fc-data/enc.json'))

directory = xmlrpc.client.Server(
    'https://{}:{}@directory.fcio.net/v2/api/rg-{}'.format(
        enc['name'],
        enc['parameters']['directory_password'],
        enc['parameters']['resource_group']))

print('Getting node data ...')
enc = directory.lookup_node(enc['name'])
with open('/tmp/fc-data/enc.json', 'w') as f:
    json.dump(enc, f, ensure_ascii=False)

print('Getting user list ...')
with open('/etc/nixos/users.json', 'w') as f:
    json.dump(directory.list_users(), f, ensure_ascii=False)

print('Getting permission list ...')
with open('/etc/nixos/permissions.json', 'w') as f:
    json.dump(directory.list_permissions(), f, ensure_ascii=False)

print('Getting admin group ...')
with open('/etc/nixos/admins.json', 'w') as f:
    json.dump(directory.lookup_resourcegroup('admins'), f, ensure_ascii=False)

print('Switching and updating channel ...')
os.system(
    'nix-channel --add https://hydra.flyingcircus.io/channels/branches/{} nixos'.
    format(enc['parameters']['environment']))

print('Building configuration ...')
os.system('nixos-rebuild switch --upgrade')
