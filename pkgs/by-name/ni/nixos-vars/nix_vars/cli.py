import argparse
import sys
from pathlib import Path
from .error import VarsError
from .eval import evaluate_config
from .generate import generate_vars, regenerate_vars
from .gc import collect_garbage
from .args import VarsArgs


def common_args(parser: argparse.ArgumentParser):
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
		"-j",
		"--json",
		type=str,
		default=None,
		metavar="<file>",
		help="Parse the vars configuration from the given JSON file",
	)

	parser.add_argument(
		"-A",
		"--attr",
		type=str,
		metavar="<attr-path>",
		help="Gets the attribute at the given path",
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


def main() -> None:
	parser = argparse.ArgumentParser(description="vars-ng-ng CLI")

	# Global arguments
	subparsers = parser.add_subparsers(
		title="commands", dest="command", required=True
	)

	eval_parser = subparsers.add_parser(
		"evaluate", help="Evaluate configuration"
	)

	common_args(eval_parser)
	gen_parser = subparsers.add_parser("generate", help="Generate secrets")

	common_args(gen_parser)
	gc_parser = subparsers.add_parser(
		"collect-garbage", help="Delete stale secrets"
	)

	common_args(gc_parser)
	deploy_parser = subparsers.add_parser("deploy", help="Deploy secrets")
	common_args(deploy_parser)

	regen_parser = subparsers.add_parser(
		"regenerate", help="Regenerate secrets"
	)

	common_args(regen_parser)
	regen_parser.add_argument(
		"-g",
		"--generator",
		dest="generators",
		type=str,
		required=True,
		default=[],
		action="append",
		help="The generators to re-run the scripts of.",
	)

	args = parser.parse_args()
	args = VarsArgs.from_dict(vars(args))

	try:
		config = evaluate_config(args)
		if args.command == "evaluate":
			print(config)
		elif args.command == "generate":
			generate_vars(args, config)
		elif args.command == "regenerate":
			regenerate_vars(args, config)
		elif args.command == "collect-garbage":
			collect_garbage(args, config)
		else:
			raise VarsError(f"Command '{args.command}' is not implemented :(")
	except VarsError as e:
		print(str(e), file=sys.stderr)
		exit(1)
