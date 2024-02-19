#!/usr/bin/env nix-shell
#!nix-shell -i python -p python3 nix

import subprocess
import json

subprocess.check_call(['nix', 'build', '.#calibre.src'])
from result.setup.browser_data import get_data

data = get_data()
with open('user-agent-data.json', 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False, sort_keys=True)
    # to pass nixpkgs newline check
    f.write('\n')
subprocess.check_call(['rm', 'result'])
