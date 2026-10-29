#!/usr/bin/env python3
"""Build in an isolated guest. Refuse pre-existing target outputs and substitutions."""
import json
import pathlib
import platform
import subprocess
import sys

root = pathlib.Path(sys.argv[1]).resolve()
expected = json.loads(pathlib.Path(sys.argv[2]).read_text())
out = pathlib.Path(sys.argv[3]).resolve()
out.mkdir(parents=True, exist_ok=True)

def run(*args, **kwargs):
    return subprocess.run(args, text=True, check=True, **kwargs)

results = {"environment": {"hostname": platform.node(), "kernel": platform.release(),
    "boot_id": pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
    "nix": run('nix', '--version', capture_output=True).stdout.strip(),
    "store_mounts": run('findmnt', '-J', '/nix/.ro-store', capture_output=True).stdout},
    "substitutions": False, "remote_builders": False, "packages": {}}
# Check every target before building any of them, including the metapackage.
for name, record in expected.items():
    check = subprocess.run(['nix', 'path-info', record['path']], capture_output=True)
    if check.returncode == 0:
        raise SystemExit(f'Refusing contaminated guest: {name} already exists')
results['preflight_all_targets_absent'] = True
(out / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
for name, record in expected.items():
    with (out / f'{name}.log').open('w') as log:
        build = subprocess.run(['nix', 'build', f'path:{root}#{name}', '--no-link',
            '--no-update-lock-file', '--print-out-paths', '--option', 'substitute', 'false',
            '--option', 'builders', '', '--cores', '3', '--max-jobs', '1', '-L'],
            text=True, stdout=log, stderr=subprocess.STDOUT)
    result = {'build_exit_code': build.returncode}
    if build.returncode == 0:
        actual_drv = run('nix', 'eval', '--raw', f'path:{root}#{name}.drvPath', capture_output=True).stdout.strip()
        result['drv'] = actual_drv
        result['derivation_matches_host'] = actual_drv == record['drv']
        if actual_drv != record['drv']:
            raise SystemExit(f'Derivation mismatch for {name}: {actual_drv}')
    if build.returncode == 0:
        result['hash'] = run('nix', 'hash', 'path', record['path'], capture_output=True).stdout.strip()
        result['matches_host'] = result['hash'] == record['hash'] if record.get('hash') else None
        result['path'] = record['path']
    results['packages'][name] = result
    (out / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
    print(name, json.dumps(result), flush=True)

if any(p["build_exit_code"] != 0 for p in results["packages"].values()):
    raise SystemExit(1)
