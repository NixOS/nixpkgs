#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=channel:nixos-unstable -i python3 -p python3 -p python3.pkgs.lxml

"""
Pandoc will try to resolve xrefs and replace them with regular links.
let’s replace them with links with empty labels which MyST
and our pandoc filters recognize as cross-references.
"""

import lxml.etree as ET
import sys

XLINK_NS = "http://www.w3.org/1999/xlink"

ns = {
    "db": "http://docbook.org/ns/docbook",
}


if __name__ == '__main__':
    assert len(sys.argv) >= 3, "usage: replace-xrefs-by-empty-links.py <input> <output>"

    tree = ET.parse(sys.argv[1])
    for xref in tree.findall(".//db:xref", ns):
        text = ET.tostring(xref, encoding=str)
        parent = xref.getparent()
        link = parent.makeelement('link')
        target_name = xref.get("linkend")
        link.set(f"{{{XLINK_NS}}}href", f"#{target_name}")
        parent.replace(xref, link)

    tree.write(sys.argv[2])
