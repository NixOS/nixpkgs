#!/usr/bin/env python3
"""Verify package source isolation using a disposable copy of the real flake."""
import json
import pathlib
import shutil
import subprocess
import tempfile

root = pathlib.Path(__file__).resolve().parents[1]
priorities = ['arkhe-verify-cli', 'arkhe-verify-wasm', 'arkhe-sdd-parser']
with tempfile.TemporaryDirectory(prefix='arkhe-source-filter-') as directory:
    copied = pathlib.Path(directory) / 'arkhe'
    def ignore(directory, names):
        return [name for name in names if name in {'.git', '__pycache__'}
            or (pathlib.Path(directory) == root / 'docs' and name == 'validation')]

    shutil.copytree(root, copied, ignore=ignore)

    def evaluate():
        expr = (
            f'let p = (builtins.getFlake {json.dumps("path:" + str(copied))}).packages.x86_64-linux; '
            'in builtins.listToAttrs (map (n: {name=n;value={src=toString p.${n}.src;drv=p.${n}.drvPath;};}) '
            '["arkhe-verify-cli" "arkhe-verify-wasm" "arkhe-sdd-parser" "arkhe-ask"])'
        )
        return json.loads(subprocess.check_output(['nix', 'eval', '--impure', '--json', '--expr', expr]))

    before = evaluate()
    unrelated = copied / 'source/apps/arkhe-ask/src/main.rs'
    unrelated.write_bytes(unrelated.read_bytes() + b'\n// Source isolation probe.\n')
    # An undeclared Cargo project and generated wasm-bindgen output must not
    # become inputs merely because they exist underneath the source root.
    stray = copied / 'source/unrelated-project/Cargo.toml'
    stray.parent.mkdir()
    stray.write_text('[package]\nname = "unrelated-project"\nversion = "0.0.0"\n')
    generated = copied / 'source/verification/crates/arkhe-verify-wasm/pkg/package.json'
    generated.parent.mkdir(exist_ok=True)
    generated.write_bytes(b'{"generatedProbe":true}\n')
    after = evaluate()
    for name in priorities:
        if before[name] != after[name]:
            raise SystemExit(f'Unrelated source edit changed {name}: {before[name]} -> {after[name]}')
    if before['arkhe-ask'] == after['arkhe-ask']:
        raise SystemExit('Positive control failed: arkhe-ask must change')
    print(json.dumps({'status': 'PASS', 'mutation': 'apps/arkhe-ask/src/main.rs comment',
        'unaffected': priorities, 'ignored_undeclared_project': True,
        'ignored_wasm_pkg_output': True, 'positive_control_changed': 'arkhe-ask',
        'before': before, 'after': after}, indent=2))
