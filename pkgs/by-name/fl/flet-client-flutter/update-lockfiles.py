from argparse import ArgumentParser
from pathlib import Path
import json
import subprocess
import yaml

THIS_FOLDER = Path(__file__).parent
FLAKE_DIR = THIS_FOLDER
while True:
    assert str(FLAKE_DIR) != '/'
    if (FLAKE_DIR / "flake.nix").exists():
        break
    FLAKE_DIR = FLAKE_DIR.parent

source = Path(subprocess.run(['nix-build', FLAKE_DIR, '-A', 'flet-client-flutter.src', '--no-out-link'], stdout=subprocess.PIPE).stdout.decode('utf-8').strip())
assert source.is_absolute()

source_pubspec_lock = source / "client" / "pubspec.lock"

output_pubspec = THIS_FOLDER / "pubspec.lock.json"
output_git_hashes = THIS_FOLDER / "git_hashes.json"

data = yaml.safe_load(source_pubspec_lock.open('r'))
output_pubspec.write_text(json.dumps(data, indent=2) + "\n")

output_data = {}

def hash_git(package):
    print(package)
    resolved_ref = package['resolved-ref']
    url = package['url']
    full_output = subprocess.run(['nix-prefetch-git', '--url', url, '--rev', resolved_ref], stdout=subprocess.PIPE).stdout.decode('utf-8')
    json_output = json.loads(full_output)
    return json_output['hash']

for name, package in data['packages'].items():
    if package['source'] != 'git':
        continue
    hash = hash_git(package['description'])
    output_data[name] = hash

output_git_hashes.write_text(json.dumps(output_data, indent=2) + "\n")
