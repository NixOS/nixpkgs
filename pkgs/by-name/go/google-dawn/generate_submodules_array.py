#! /usr/bin/env nix-shell
#! nix-shell -i python -p python310 nix-prefetch-git git
"""
generate_submodules_array.py

Reads:
  - DEPS file from Dawn
  - tools/fetch_dawn_dependencies.py to get 'required_submodules'
Parses submodules that are Git-based (url@commit), calls `nix-prefetch-git` to
retrieve the sha256, then outputs Nix code:

  submodules = [
    {
      path = "third_party/abseil-cpp";
      src = {
        url    = "...";
        rev    = "...";
        sha256 = "...";
      };
    }
    ...
  ];

Usage:
  python3 generate_submodules_array_with_sha.py \
      --deps-file /path/to/dawn/DEPS \
      --fetch-dawn-deps-file /path/to/dawn/tools/fetch_dawn_dependencies.py
"""

import argparse
import ast
import json
import re
import sys
import subprocess
from pathlib import Path

def main():
    parser = argparse.ArgumentParser(description='Generate a Nix array of submodules (with sha256) from Dawn DEPS.')
    parser.add_argument('--deps-file', required=True,
                        help='Path to the Dawn DEPS file')
    parser.add_argument('--fetch-dawn-deps-file', required=True,
                        help='Path to the Dawn tools/fetch_dawn_dependencies.py file')
    args = parser.parse_args()

    # 1) Read Dawn's DEPS file
    with open(args.deps_file, 'r', encoding='utf-8') as f:
        deps_code = f.read()

    # We mock out 'Var(...)' calls so that the DEPS can be exec'd without failing.
    class VarMock:
        """Mock object for 'Var' calls inside DEPS."""
        def __init__(self, name):
            self.name = name
        def __add__(self, other):
            return f"{self.name}{other}"
        def __radd__(self, other):
            return f"{other}{self.name}"
        def __str__(self):
            return self.name

    deps_globals = {}
    deps_locals = {
        'Var': VarMock,
        'Str': str,
        'True': True,
        'False': False,
        'None': None,
    }
    exec(deps_code, deps_globals, deps_locals)

    # 2) Extract the 'deps' dict and 'vars' dict
    if 'deps' not in deps_locals:
        print("ERROR: The DEPS file does not define 'deps'.", file=sys.stderr)
        sys.exit(1)
    deps_dict = deps_locals['deps']

    if 'vars' in deps_locals:
        vars_dict = deps_locals['vars']
    else:
        vars_dict = {}

    # 3) Read the tools/fetch_dawn_dependencies.py and locate required_submodules
    with open(args.fetch_dawn_deps_file, 'r', encoding='utf-8') as f:
        fetch_dawn_code = f.read()

    pattern = re.compile(r'required_submodules\s*=\s*\[\s*(.*?)\]', re.DOTALL)
    match = pattern.search(fetch_dawn_code)
    if not match:
        print("ERROR: Could not find `required_submodules` list in fetch_dawn_dependencies.py.")
        sys.exit(1)

    submodules_list_str = "[" + match.group(1) + "]"
    try:
        required_submodules = ast.literal_eval(submodules_list_str)
    except Exception as e:
        print(f"ERROR: Could not parse required_submodules.\n{e}", file=sys.stderr)
        sys.exit(1)

    # 4) For each required_submodule, if it has a "url" with '@commit' in DEPS, parse out url & rev
    def expand_url(raw_url: str, variables: dict) -> str:
        """Expand placeholders like {chromium_git} with 'variables' dict."""
        return raw_url.format(**variables)

    submodules_info = []

    for submodule_path in required_submodules:
        dep_info = deps_dict.get(submodule_path)
        # Possibly none or CIPD. We only care if there's a "url" with an '@commit'.
        if not dep_info or not isinstance(dep_info, dict):
            continue
        raw_url = dep_info.get('url', None)
        if not raw_url:
            continue

        url_expanded = expand_url(raw_url, vars_dict)
        if '@' not in url_expanded:
            continue  # No pinned commit?

        repo_url, rev = url_expanded.rsplit('@', 1)
        submodules_info.append((submodule_path, repo_url, rev))

    # 5) For each submodule, call nix-prefetch-git <url> <rev> to get the sha256
    #    Then build up an array of dicts: { path, url, rev, sha256 }
    results = []
    for (path_str, url, rev) in submodules_info:
        print(f"Fetching sha256 for {path_str} => {url}@{rev}", file=sys.stderr)
        # e.g.:
        #  nix-prefetch-git https://github.com/foo/bar.git <commit>
        # returns JSON, parse the .sha256 field
        try:
            proc = subprocess.run(
                ["nix-prefetch-git", url, rev],
                check=True,
                capture_output=True,
                text=True
            )
            # parse JSON
            data = json.loads(proc.stdout)
            sha256 = data["hash"]
        except Exception as e:
            print(f"WARNING: Failed to prefetch submodule {path_str}:\n{e}", file=sys.stderr)
            # Fallback to a dummy. We'll continue instead of exiting.
            sha256 = "0000000000000000000000000000000000000000000000000000"

        results.append({
            "path": path_str,
            "url": url,
            "rev": rev,
            "sha256": sha256
        })

    # 6) Print the submodules array in the requested format
    #    submodules = [
    #      {
    #        path = "third_party/abseil-cpp";
    #        src = fetchgit {
    #          url = "...";
    #          rev = "...";
    #          sha256 = "...";
    #        };
    #      }
    #      ...
    #    ];
    print('[')
    for info in results:
        print('  {')
        print(f'    path = "{info["path"]}";')
        print('    src = {')
        print(f'      url    = "{info["url"]}";')
        print(f'      rev    = "{info["rev"]}";')
        print(f'      sha256 = "{info["sha256"]}";')
        print(f'      fetchSubmodules = false;')
        print('    };')
        print('  }')
    print(']')

if __name__ == "__main__":
    main()

