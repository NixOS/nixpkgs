#!/usr/bin/env python3
# Concatenate the ExtJS sources into the single proxmox-backup-gui.js bundle,
# using the file list from the upstream www/Makefile (expanding TAPE_UI_FILES
# inside JSSRC) and prepending our LogoShim plus the generated online-help map.
from pathlib import Path

mk = Path('www/Makefile').read_text().splitlines()
vars = {}
i = 0
while i < len(mk):
    line = mk[i]
    if line.startswith(('TAPE_UI_FILES=', 'JSSRC=')):
        name, rest = line.split('=', 1)
        vals = []
        cur = rest
        while True:
            cur = cur.strip()
            cont = cur.endswith('\\')
            if cont:
                cur = cur[:-1].strip()
            if cur:
                vals.append(cur)
            if not cont:
                break
            i += 1
            cur = mk[i]
        vars[name] = vals
    i += 1
files = []
for item in vars['JSSRC']:
    if item.endswith('TAPE_UI_FILES}'):
        files.extend(vars['TAPE_UI_FILES'])
    else:
        files.append(item)
with open('www/js/proxmox-backup-gui.js', 'wb') as out:
    for f in ['LogoShim.js', 'OnlineHelpInfo.js'] + files:
        out.write(Path('www', f).read_bytes())
        out.write(b'\n')
