#!/usr/bin/env python3
# The dashboard NodeInfo panel shows an APT "repository status" row that always
# reports "No Proxmox Backup Server repository enabled!" on this NixOS port
# (there are no APT repos here). Replace it with a static row pointing out this
# is a nixpkgs build instead.
from pathlib import Path

p = Path('www/panel/NodeInfo.js')
s = p.read_text()

old = """        {
            xtype: 'pmxNodeInfoRepoStatus',
            itemId: 'repositoryStatus',
            product: 'Proxmox Backup Server',
            repoLink: '#pbsServerAdministration:aptrepositories',
        },
"""
new = """        {
            itemId: 'nixpkgsBuild',
            colspan: 2,
            printBar: false,
            title: gettext('Packaging'),
            text: 'nixpkgs',
        },
"""

assert old in s, 'repository status row not found in NodeInfo.js'
s = s.replace(old, new)
p.write_text(s)
