"""Seed sub{u,g}id from /var/lib/nixos/auto-subuid-map once."""

import json
import sys
from pathlib import Path

LEGACY_MAP = Path("/var/lib/nixos/auto-subuid-map")
SENTINEL = Path("/var/lib/userborn/auto-subuid-map-imported")

directory = Path(sys.argv[1] if len(sys.argv) > 1 else "/etc")
directory.mkdir(parents=True, exist_ok=True)
SENTINEL.parent.mkdir(parents=True, exist_ok=True)

if LEGACY_MAP.exists():
    auto = json.loads(LEGACY_MAP.read_text())
    for fname in ("subuid", "subgid"):
        path = directory / fname
        text = path.read_text() if path.exists() else ""
        seen = {ln.split(":", 1)[0] for ln in text.splitlines() if ":" in ln}
        with path.open("a") as f:
            for name, start in sorted(auto.items()):
                if name not in seen:
                    line = f"{name}:{start}:65536"
                    f.write(line + "\n")
                    print(f"<6>seeded {fname}: {line}", file=sys.stderr)

SENTINEL.touch()
