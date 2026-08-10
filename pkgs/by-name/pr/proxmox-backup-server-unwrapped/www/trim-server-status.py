#!/usr/bin/env python3
# Server Status: remove the Package versions, Console, Reboot and Shutdown
# buttons (none apply to this NixOS port), leaving just the RRD type selector.
from pathlib import Path

p = Path('www/ServerStatus.js')
s = p.read_text()
start = s.index('        var node_command = function (cmd) {')
end = s.index('];', s.index('me.tbar = [')) + len('];')
s = s[:start] + "me.tbar = ['->', { xtype: 'proxmoxRRDTypeSelector' }];" + s[end:]
assert 'restartBtn' not in s and 'shutdownBtn' not in s and 'consoleBtn' not in s and 'version_btn' not in s
p.write_text(s)
