#!/usr/bin/env python3
# Remove the "Shell" (xterm.js console) entry from the navigation tree;
# there is no host shell to attach to on this NixOS port.
from pathlib import Path

p = Path('www/NavigationTree.js')
s = p.read_text()
s = s.replace("""                    {
                        text: gettext('Shell'),
                        iconCls: 'fa fa-terminal',
                        path: 'pbsXtermJsConsole',
                        leaf: true,
                    },
""", "")
p.write_text(s)
