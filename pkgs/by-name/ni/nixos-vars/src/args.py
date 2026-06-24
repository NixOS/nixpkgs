from dataclasses import dataclass
from pathlib import Path
from typing import Optional, Any, Self, Mapping
from .error import VarsError


@dataclass
class VarsArgs:
	file: Optional[Path]
	flake: Optional[str]
	json: Optional[str]
	attr: Optional[str]
	dry_run: bool
	yes: bool
	command: str  # gotta figure out how to type this properly

	def from_dict(d: Mapping[str, Any]) -> Self:
		args = VarsArgs(**d)

		configSources = []

		if args.file is not None:
			configSources.append(args.file)
		if args.flake is not None:
			configSources.append(args.flake)
		if args.json is not None:
			configSources.append(args.json)

		if len(configSources) != 1:
			raise VarsError(
				"Precisely one of the --file, --flake, or --json flags must be provided"
			)

		if args.attr and not args.file:
			raise VarsError("--attr is only supported for --file")

		return args
