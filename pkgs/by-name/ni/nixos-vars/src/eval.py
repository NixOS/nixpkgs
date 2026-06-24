import json
import subprocess
from pathlib import Path
from typing import Any
from .error import VarsError
from .args import VarsArgs
from .config import VarsConfig

jsonify = Path(__file__).parent / "nix" / "jsonify.nix"


def evaluate_config(args: VarsArgs) -> VarsConfig:
	return VarsConfig.from_jsom(evaluate_config_raw(args))


def evaluate_config_raw(args: VarsArgs) -> Any:
	if args.json is not None:
		try:
			with open(args.json) as f:
				return json.loads(f.read())
		except json.decoder.JSONDecodeError as e:
			raise VarsError(f"Error parsing JSON: {e}")
	elif args.flake is not None:
		expr = f"config: import {jsonify} {{ inherit config; }}"
		# Currently passing --impure since `jsonify` is an absolute path...
		evalCommand = [args.flake, "--impure", "--apply", expr]
	elif args.file is not None:
		expr = f"""
import {jsonify} {{
	config = (import ./{args.file}){"" if args.attr is None else f".{args.attr}"};
}}
"""
		evalCommand = ["--impure", "-E", expr]

	try:
		result = subprocess.run(
			["nix", "eval", "--json", *evalCommand],
			capture_output=True,
			text=True,
			check=True,
		)

		return json.loads(result.stdout)
	except subprocess.CalledProcessError as e:
		raise VarsError(f"Error evaluating nix expression:\n{e.stderr}")
