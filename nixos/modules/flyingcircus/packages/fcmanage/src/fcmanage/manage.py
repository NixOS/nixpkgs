"""Update NixOS system configuration from infrastructure or local sources."""

from fc.util.directory import connect

import argparse
import filecmp
import json
import logging
import os
import os.path as p
import shutil
import socket
import tempfile

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


def load_enc(enc_path):
    """Tries to read enc.json"""
    global enc
    try:
        with open(enc_path) as f:
            enc = json.load(f)
    except OSError:
        # This environment doesn't seem to support an ENC,
        # i.e. Vagrant. Silently ignore for now.
        return


def conditional_update(filename, data):
    """Updates JSON file on disk only if there is different content."""
    with tempfile.NamedTemporaryFile(
            mode='w', suffix='.tmp', prefix=p.basename(filename),
            dir=p.dirname(filename), delete=False) as tf:
        json.dump(data, tf, ensure_ascii=False, indent=1, sort_keys=True)
        os.chmod(tf.fileno(), 0o640)
    if not(p.exists(filename)):
        os.rename(tf.name, filename)
    elif not(filecmp.cmp(filename, tf.name)):
        os.rename(tf.name, filename)
    else:
        os.unlink(tf.name)


def write_json(calls):
    """Writes JSON files from a list of (lambda, filename) pairs."""
    for lookup, target in calls:
        print('Retrieving {} ...'.format(target))
        try:
            data = lookup()
        except Exception:
            logging.exception('Error retrieving data:')
            continue
        conditional_update('/etc/nixos/{}'.format(target), data)


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
        try:
            with open('/proc/cpuinfo') as f:
                cores = 0
                for line in f:
                    if line.startswith('processor'):
                        cores += 1
            result['cores'] = cores
        except IOError:
            pass
        return result

    write_json([
        (lambda: load_system_state(), 'system_state.json'),
    ])


def update_inventory():
    if 'directory_password' not in enc['parameters']:
        print('No directory password. Not updating inventory.')
        return
    try:
        directory = connect(enc, enc['parameters']['directory_ring'])
    except socket.error:
        print('No directory connection. Not updating inventory.')
        return

    write_json([
        (lambda: directory.lookup_node(enc['name']), 'enc.json'),
        (lambda: directory.list_nodes_addresses(
            enc['parameters']['location'], 'srv'), 'addresses_srv.json'),
        (lambda: directory.list_permissions(), 'permissions.json'),
        (lambda: directory.list_service_clients(), 'service_clients.json'),
        (lambda: directory.list_services(), 'services.json'),
        (lambda: directory.list_users(), 'users.json'),
        (lambda: directory.lookup_resourcegroup('admins'), 'admins.json'),
    ])


def build_channel(build_options):
    print('Switching channel ...')
    try:
        if enc:
            channel_url = enc['parameters']['environment_url']
            subprocess.check_call(
                ['nix-channel', '--add', channel_url, 'nixos'])
        subprocess.check_call(['nix-channel', '--update'])
        subprocess.check_call(
            ['nixos-rebuild', '--no-build-output', 'switch'] + build_options)
    except Exception:
        logging.exception('Error switching channel ')


def build_dev(build_options):
    print('Switching to development environment')
    try:
        subprocess.check_call(['nix-channel', '--remove', 'nixos'])
    except Exception:
        logging.exception('Error removing channel ')
    subprocess.check_call(
        ['nixos-rebuild', '-I', 'nixpkgs=/root/nixpkgs', 'switch'] +
        build_options)


def maintenance():
    import fc.maintenance.reqmanager
    fc.maintenance.reqmanager.transaction()


def seed_enc(path):
    if os.path.exists(path):
        return
    if not os.path.exists('/tmp/fc-data/enc.json'):
        return
    shutil.move('/tmp/fc-data/enc.json', path)


def collect_garbage(age):
    subprocess.check_call(['nix-collect-garbage', '--delete-older-than',
                           '{}d'.format(age)])


def main():
    build_options = []
    a = argparse.ArgumentParser(description=__doc__)
    a.add_argument('-E', '--enc-path', default='/etc/nixos/enc.json',
                   help='path to enc.json (default: %(default)s)')
    a.add_argument('--show-trace', default=False, action='store_true',
                   help='instruct nixos-rebuild to dump tracebacks on failure')
    a.add_argument('-e', '--directory', default=False, action='store_true',
                   help='refresh local ENC copy')
    a.add_argument('-s', '--system-state', default=False, action='store_true',
                   help='dump local system information (like memory size) '
                   'to system_state.json')
    a.add_argument('-m', '--maintenance', default=False, action='store_true',
                   help='run scheduled maintenance')
    a.add_argument('-g', '--garbage', default=0, type=int,
                   help='collect garbage and remove generations older than '
                        '<INT> days')

    build = a.add_mutually_exclusive_group()
    build.add_argument('-c', '--channel', default=False, dest='build',
                       action='store_const', const='build_channel',
                       help='switch machine to FCIO channel')
    build.add_argument('-d', '--development', default=False, dest='build',
                       action='store_const', const='build_dev',
                       help='switch machine to local checkout in '
                       '/root/nixpkgs')
    a.add_argument('-v', '--verbose', action='store_true', default=False)
    args = a.parse_args()

    logging.basicConfig(format='%(levelname)s: %(message)s',
                        level=logging.DEBUG if args.verbose else logging.INFO)
    # this is really annoying
    logging.getLogger('iso8601').setLevel(logging.INFO)

    seed_enc(args.enc_path)

    if args.show_trace:
        build_options.append('--show-trace')

    if args.directory:
        load_enc(args.enc_path)
        update_inventory()

    if args.system_state:
        system_state()

    # reload ENC data in case update_inventory changed something
    load_enc(args.enc_path)

    if args.build:
        globals()[args.build](build_options)

    if not args.build and not args.directory and not args.system_state:
        a.error('no action specified')

    if args.maintenance:
        maintenance()

    # Garbage collection is run after a potential reboot.
    if args.garbage:
        collect_garbage(args.garbage)


if __name__ == '__main__':
    main()
