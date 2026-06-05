import argparse
import os
import sys
from pathlib import Path
from typing import Optional
from .error import VarsError
from .eval import evaluate_config
from .args import VarsArgs


def main() -> None:
	parser = argparse.ArgumentParser(description="vars-ng-ng CLI")

	# Global arguments
	parser.add_argument(
		"-f",
		"--file",
		type=Path,
		default=None,
		metavar="<file>",
		help="Path to config.nix",
	)

	parser.add_argument(
		"-F",
		"--flake",
		type=str,
		default=None,
		metavar="<flake-uri#name>",
		help="Flake-based alternative to --file",
	)

	parser.add_argument(
		"-A",
		"--attr",
		type=str,
		metavar="<attr-path>",
		help="Gets the attribute at the given path",
	)

	parser.add_argument(
		"--nixpkgs",
		type=str,
		required="NIX_PATH" not in os.environ,
		metavar="<path>",
		help="Path to nixpkgs tree (default: import from NIX_PATH)",
	)

	parser.add_argument(
		"--dry-run",
		action="store_true",
		help="Print what would be done without executing",
	)

	parser.add_argument(
		"-y",
		"--yes",
		action="store_true",
		help="Automatically confirm all backend execution prompts (dangerous)",
	)

	subparsers = parser.add_subparsers(
		title="commands", dest="command", required=True
	)

	subparsers.add_parser("evaluate", help="Evaluate configuration")
	subparsers.add_parser("generate", help="todo")
	subparsers.add_parser("regenerate", help="todo")
	subparsers.add_parser("collect-garbage", help="todo")
	subparsers.add_parser("deploy", help="todo")

	args = parser.parse_args()
	args = VarsArgs(**vars(args))
	print(args)

	try:
		if args.command == "evaluate":
			evaluate_config(args)
		else:
			raise VarsError(f"Command '{args.command}' is not implemented :(")
	except VarsError as e:
		print(str(e), file=sys.stderr)
		exit(1)
