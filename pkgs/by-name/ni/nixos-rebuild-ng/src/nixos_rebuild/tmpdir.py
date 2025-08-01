from pathlib import Path
from tempfile import TemporaryDirectory
from typing import Final

TMPDIR: Final = TemporaryDirectory(prefix="nixos-rebuild.")
TMPDIR_PATH: Final = Path(TMPDIR.name)
