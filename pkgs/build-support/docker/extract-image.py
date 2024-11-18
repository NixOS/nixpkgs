from pathlib import Path
from argparse import ArgumentParser
from tempfile import TemporaryDirectory
from tarfile import TarFile
import json
import shlex
import stat
import shutil

parser = ArgumentParser(description="Extracts the layers of a OCI container")
parser.add_argument("image", type=Path)
parser.add_argument("output", type=Path)
parser.add_argument("--generate-wrapper-args", type=Path)
parser.add_argument("--generate-entrypoint", type=Path)

wrapper_args = []

args = parser.parse_args()
print('args', args)

with TemporaryDirectory() as td:
    td = Path(td)
    with TarFile.open(args.image, 'r') as image:
        image.extractall(td)
    manifest = json.loads((td / "manifest.json").read_text())
    assert len(manifest) == 1
    manifest = manifest[0]
    config = json.loads((td / manifest['Config']).read_text())
    config = config['config']
    for layer in manifest['Layers']:
        with TarFile.open(td / layer) as layer:
            layer.extractall(args.output)
    print('config', config)

if args.generate_wrapper_args is not None:
    with args.generate_wrapper_args.open('w') as f:
        for arg in wrapper_args:
            print(arg, file=f)

if args.generate_entrypoint is not None:
    with args.generate_entrypoint.open('w') as f:
        def write_line(*args):
            print(*args, file=f)
        write_line(f"#!/usr/bin/env {shutil.which('bash')}")
        for env in config['Env']:
            k, *v = env.split('=')
            v = '='.join(v)
            write_line(f"export {k}={shlex.quote(v)}")
        working_dir = config.get('WorkingDir', '/')
        write_line(f'cd "{shlex.quote(working_dir)}"')
        write_line('args=()')
        for arg in config['Entrypoint']:
            write_line(f'args+=({shlex.quote(arg)})')
        write_line('if [[ $# == 0 ]]; then')
        for arg in config['Cmd']:
            write_line(f'args+=({shlex.quote(arg)})')
        write_line('fi')
        write_line('echo exec "${args[@]}" "$@"')
        write_line('exec "${args[@]}" "$@"')
    filename = args.generate_entrypoint
    filename.chmod(filename.stat().st_mode | stat.S_IEXEC)
