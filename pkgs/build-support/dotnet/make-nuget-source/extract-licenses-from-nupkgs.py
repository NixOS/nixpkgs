#!/usr/bin/env python3
"""
Opens each .nupkg file in a directory, and extracts the SPDX license identifiers
from them if they exist. The SPDX license identifier is stored in the
'<license type="expression">...</license>' tag in the .nuspec file.
All found license identifiers will be printed to stdout.
"""

from glob import glob
from pathlib import Path
import sys
import xml.etree.ElementTree as ET
import zipfile

all_licenses = set()

if len(sys.argv) < 2:
    print(f"Usage: {sys.argv[0]} DIRECTORY")
    sys.exit(1)

nupkg_dir = Path(sys.argv[1])
for nupkg_name in glob("*.nupkg", root_dir=nupkg_dir):
    with zipfile.ZipFile(nupkg_dir / nupkg_name) as nupkg:
        for nuspec_name in [name for name in nupkg.namelist() if name.endswith(".nuspec")]:
            with nupkg.open(nuspec_name) as nuspec_stream:
                nuspec = ET.parse(nuspec_stream)
                licenses = nuspec.findall(".//{*}license[@type='expression']")
                all_licenses.update([license.text for license in licenses])

print("\n".join(sorted(all_licenses)))
