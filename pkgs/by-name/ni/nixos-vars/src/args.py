from dataclasses import dataclass
from pathlib import Path
from typing import Optional


@dataclass
class VarsArgs:
	file: Optional[Path]
	flake: Optional[str]
	nixpkgs: Optional[Path]
	attr: Optional[str]
	dry_run: bool
	yes: bool
	command: str  # gotta figure out how to type this properly
