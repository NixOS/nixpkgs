#!/usr/bin/env python3
"""Copy only pinned build inputs and sources to a fresh SSH guest."""
import argparse
import json
import os
import pathlib
import shlex
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('flake_dir', type=pathlib.Path)
parser.add_argument('destination', help='SSH destination, e.g. root@127.0.0.1')
parser.add_argument('--identity-file', required=True)
parser.add_argument('--port', type=int, default=22429)
parser.add_argument('--known-hosts-file', required=True)
parser.add_argument('--guest-dir', default='/root/arkhe')
parser.add_argument('--evidence-dir', type=pathlib.Path, required=True)
args = parser.parse_args()
root = args.flake_dir.resolve()
args.evidence_dir.mkdir(parents=True, exist_ok=True)
env = os.environ.copy()
opts = ['-i', args.identity_file, '-p', str(args.port), '-o', 'BatchMode=yes',
    '-o', 'StrictHostKeyChecking=yes', '-o', 'UserKnownHostsFile=' + args.known_hosts_file]
env['NIX_SSHOPTS'] = shlex.join(opts)

def run(*command, **kwargs):
    return subprocess.run(command, env=env, check=True, **kwargs)

expr = ('builtins.mapAttrs (_: p: { path = p.outPath; drv = p.drvPath; }) '
    f'(builtins.removeAttrs (builtins.getFlake {json.dumps("path:" + str(root))})'
    '.packages.x86_64-linux [ "default" ])')
expected = json.loads(run('nix', 'eval', '--impure', '--json', '--expr', expr,
    stdout=subprocess.PIPE).stdout)
# Keep the metapackage last, because all its constituent outputs must be guest-built.
expected = {k: expected[k] for k in sorted(expected, key=lambda k: (k == 'arkhe', k))}
refs = [f'path:{root}#{k}' for k in expected]
target_drvs = {record['drv'] for record in expected.values()}
data = json.loads(run('nix', 'derivation', 'show', *refs, stdout=subprocess.PIPE).stdout)
deps = {}
srcs = set()
for d in data.get('derivations', data).values():
    if 'inputs' in d:
        for drv, spec in d['inputs']['drvs'].items():
            if '/nix/store/' + drv not in target_drvs:
                deps.setdefault('/nix/store/' + drv, set()).update(spec['outputs'])
        srcs.update('/nix/store/' + s for s in d['inputs']['srcs'])
    else:
        for drv, outputs in d['inputDrvs'].items():
            if drv not in target_drvs:
                deps.setdefault(drv, set()).update(outputs)
        srcs.update(d['inputSrcs'])
paths = set(srcs)
for drv, outputs in sorted(deps.items()):
    paths.update(run('nix', 'build', drv + '^' + ','.join(sorted(outputs)),
        '--no-link', '--print-out-paths', stdout=subprocess.PIPE).stdout.decode().splitlines())
pkgs = run('nix', 'eval', '--raw', '--impure', '--expr',
    f'(builtins.getFlake {json.dumps("path:" + str(root))}).inputs.nixpkgs.outPath',
    stdout=subprocess.PIPE).stdout.decode()
paths.add(pkgs)
closure = set(run('nix-store', '-qR', *sorted(paths), stdout=subprocess.PIPE).stdout.decode().splitlines())
targets = {record['path'] for record in expected.values()}
if targets & closure:
    raise SystemExit('Refusing to seed an Arkhe target output into the guest')
for record in expected.values():
    h = subprocess.run(['nix', 'hash', 'path', record['path']], env=env, capture_output=True, text=True)
    record['hash'] = h.stdout.strip() if h.returncode == 0 else None
(args.evidence_dir / 'expected-host.json').write_text(json.dumps(expected, indent=2) + '\n')
(args.evidence_dir / 'seed-paths.json').write_text(json.dumps({
    'targets_not_copied': sorted(targets), 'seed_paths': sorted(paths),
    'seed_closure_count': len(closure)}, indent=2) + '\n')
# Locally built vendor directories are unsigned. Only build inputs, never Arkhe
# outputs, are imported as trusted inputs for this comparison.
run('nix', 'copy', '--no-check-sigs', '--to', 'ssh-ng://' + args.destination, *sorted(paths))
ssh = ['ssh', *opts, args.destination]
guest = shlex.quote(args.guest_dir)
run(*ssh, 'mkdir -p ' + guest)
tar = subprocess.Popen(['tar', '-C', str(root), '--exclude=./docs', '--exclude=./.git', '-cf', '-', '.'],
    env=env, stdout=subprocess.PIPE)
run(*ssh, 'tar -C ' + guest + ' -xf -', stdin=tar.stdout)
tar.stdout.close()
if tar.wait() != 0:
    raise SystemExit('Source archive failed')
run('scp', '-i', args.identity_file, '-P', str(args.port), '-o', 'BatchMode=yes',
    '-o', 'UserKnownHostsFile=' + args.known_hosts_file,
    str(args.evidence_dir / 'expected-host.json'), args.destination + ':' + args.guest_dir + '/expected-host.json')
print('Guest seeded without any Arkhe target output')
