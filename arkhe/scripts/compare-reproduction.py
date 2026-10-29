#!/usr/bin/env python3
"""Compare final host hashes to the original guest build evidence."""
import json
import pathlib
import sys

expected = json.loads(pathlib.Path(sys.argv[1]).read_text())
guest = json.loads(pathlib.Path(sys.argv[2]).read_text())
if (not expected or set(expected) != set(guest['packages'])
        or not guest.get('preflight_all_targets_absent')
        or guest.get('substitutions') is not False
        or guest.get('remote_builders') is not False):
    raise SystemExit('Incomplete results or invalid guest preflight')
packages = {}
for name, host in expected.items():
    vm = guest['packages'][name]
    match = (vm['build_exit_code'] == 0 and bool(host.get('hash'))
        and vm.get('hash') == host['hash'] and vm.get('path') == host['path']
        and vm.get('drv') == host['drv'])
    packages[name] = {'match': match, 'host_hash': host['hash'],
        'guest_hash': vm.get('hash'), 'drv': host['drv'], 'path': host['path']}
all_match = all(p['match'] for p in packages.values())
print(json.dumps({'status': 'PASS' if all_match else 'FAIL',
    'package_count': len(packages), 'guest': guest['environment'],
    'packages': packages}, indent=2))
if not all_match:
    raise SystemExit(1)
