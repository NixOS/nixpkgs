#!@python3@
"""Seed /etc/sub{u,g}id from /var/lib/nixos/auto-subuid-map.

update-users-groups.pl rebuilds /etc/sub{u,g}id from scratch on every
activation, so a user that was removed from the config has no line there but
is still recorded in auto-subuid-map. nixos-subids preserves whatever it
finds in /etc/sub{u,g}id and never deletes entries; seeding the file once
from the legacy map is therefore enough to guarantee that such a user, if
re-added later, gets its old range back instead of a fresh one.

Runs at most once, gated by ConditionPathExists in the unit. Can be removed
once the perl script is no longer used.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

LEGACY_MAP = Path("/var/lib/nixos/auto-subuid-map")
STATE = Path("/var/lib/nixos-subids")
SENTINEL = STATE / ".legacy-imported"


def existing_names(path: Path) -> set[str]:
    try:
        text = path.read_text()
    except FileNotFoundError:
        return set()
    return {line.split(":", 1)[0] for line in text.splitlines() if line and ":" in line}


def main() -> None:
    directory = Path(sys.argv[1] if len(sys.argv) > 1 else "/etc")
    directory.mkdir(parents=True, exist_ok=True)
    STATE.mkdir(parents=True, exist_ok=True)

    try:
        auto: dict[str, int] = json.loads(LEGACY_MAP.read_text())
    except FileNotFoundError:
        SENTINEL.touch()
        return

    for fname in ("subuid", "subgid"):
        path = directory / fname
        seen = existing_names(path)
        new = [
            f"{name}:{start}:65536\n"
            for name, start in sorted(auto.items())
            if name not in seen
        ]
        if new:
            with path.open("a") as f:
                f.write("".join(new))
            for line in new:
                print(
                    f"<6>nixos-subids-import-legacy: seeded {fname}: {line.rstrip()}",
                    file=sys.stderr,
                )

    SENTINEL.touch()


if __name__ == "__main__":
    main()
