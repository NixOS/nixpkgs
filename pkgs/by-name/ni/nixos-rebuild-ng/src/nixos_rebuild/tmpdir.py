from pathlib import Path
from tempfile import TemporaryDirectory

TMPDIR = TemporaryDirectory(prefix="nixos-rebuild.")
TMPDIR_PATH = Path(TMPDIR.name)
