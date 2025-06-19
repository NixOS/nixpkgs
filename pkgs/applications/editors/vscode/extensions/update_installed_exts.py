#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p cacert nix python3 python3Packages.requests


"""
can be added to your configuration with the following command and snippet:
$ ./pkgs/applications/editors/vscode/extensions/update_installed_exts.py > extensions.nix

(vscode-with-extensions.override {
  vscodeExtensions = map (
    extension:
    vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        inherit (extension)
          name
          publisher
          version
          hash
          ;
      };
    }
  ) (import ./extensions.nix).extensions;
})
"""

import atexit
import json
import shutil
import signal
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

import requests

tmp_dirs = []


def cleanup_all():
    for d in list(tmp_dirs):
        shutil.rmtree(d, ignore_errors=True)
        tmp_dirs.remove(d)


atexit.register(cleanup_all)


def fail(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


session = requests.Session()
adapter = requests.adapters.HTTPAdapter(max_retries=3)
session.mount("https://", adapter)


def download_and_process(owner, name):
    n = f"{owner}.{name}"
    url = (
        f"https://{owner}.gallery.vsassets.io/_apis/public/"
        f"gallery/publisher/{owner}/extension/{name}/latest/"
        "assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    )

    td = tempfile.mkdtemp(prefix="vscode_exts_")
    tmp_dirs.append(td)
    try:
        zpath = Path(td) / f"{n}.zip"
        r = session.get(url, stream=True, timeout=10)
        if r.status_code == 404:
            return ""
        r.raise_for_status()
        with zpath.open("wb") as f:
            for chunk in r.iter_content(8192):
                f.write(chunk)

        with zipfile.ZipFile(zpath) as z:
            pkg = z.read("extension/package.json")
        ver = json.loads(pkg)["version"]

        res = subprocess.run(
            ["nix", "hash", "file", str(zpath)],
            check=False,
            capture_output=True,
            text=True,
        )
        if res.returncode:
            fail(res.stderr.strip())
        h = res.stdout.strip()

        return f'  {{ name = "{name}"; publisher = "{owner}"; version = "{ver}"; hash = "{h}"; }}'
    finally:
        if td in tmp_dirs:
            shutil.rmtree(td, ignore_errors=True)
            tmp_dirs.remove(td)


if __name__ == "__main__":
    code = (
        sys.argv[1]
        if len(sys.argv) > 1
        else shutil.which("code") or shutil.which("codium")
    )
    if not code:
        fail("VSCode executable not found")

    def on_int(signum, frame):
        print("Interrupted, exiting", file=sys.stderr)
        sys.exit(1)

    signal.signal(signal.SIGINT, on_int)

    try:
        exts = subprocess.check_output(
            [code, "--list-extensions"], text=True
        ).splitlines()
    except Exception as e:
        fail(str(e))

    print("{ extensions = [")
    for ext in exts:
        if "." in ext:
            owner, name = ext.split(".", 1)
            entry = download_and_process(owner, name)
            if entry:
                print(entry)
    print("];\n}")
