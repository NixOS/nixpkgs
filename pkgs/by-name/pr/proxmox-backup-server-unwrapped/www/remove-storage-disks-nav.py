#!/usr/bin/env python3
# Remove the "Storage / Disks" entry from the navigation tree. Disk management
# (partitioning, mkfs, and especially writing systemd .mount units) cannot work
# on this NixOS port: PBS would write units into /etc/systemd/system, which is a
# read-only nix-store path, so the whole menu is a dead end here.
from pathlib import Path

p = Path('www/NavigationTree.js')
s = p.read_text()
s = s.replace("""                    {
                        text: gettext('Storage / Disks'),
                        iconCls: 'fa fa-hdd-o',
                        path: 'pbsStorageAndDiskPanel',
                        leaf: true,
                    },
""", "")
p.write_text(s)
