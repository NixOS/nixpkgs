import json
import subprocess
from pathlib import Path
from typing import Any
from .error import VarsError
from .args import VarsArgs
from .config import VarsConfig

jsonify_path = Path(__file__).parent / "nix" / "jsonify.nix"
with open(jsonify_path) as f:
    jsonify_source = f.read()


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
        expr = f"configuration: ({jsonify_source}) {{ inherit configuration; }}"
        evalCommand = [
            "nix",
            "eval",
            "--json",
            args.flake,
            "--apply",
            expr,
        ]

        if args.verbose:
            evalCommand.append("--show-trace")
    elif args.file is not None:
        expr = f"""
({jsonify_source}) {{
    configuration = (import {args.file.resolve()}){"" if args.attr is None else f".{args.attr}"};
}}
"""
        evalCommand = [
            "nix-instantiate",
            "--eval",
            "--json",
            "--strict",
            "--expr",
            "--read-write-mode",
            expr,
        ]

    try:
        result = subprocess.run(
            evalCommand,
            capture_output=True,
            text=True,
            check=True,
        )

        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        raise VarsError(f"Error evaluating nix expression:\n{e.stderr}")
