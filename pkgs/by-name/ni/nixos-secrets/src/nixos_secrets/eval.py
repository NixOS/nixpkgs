import json
import subprocess
import functools
from pathlib import Path
from typing import Any, Optional
from .error import SecretsError
from .args import SecretsArgs
from .config import SecretsConfig

jsonify_path = Path(__file__).parent / "nix" / "jsonify.nix"
with open(jsonify_path) as f:
    jsonify_source = f.read()

schema_path = Path(__file__).parent / "secrets-config.schema.json"


def evaluate_config(args: SecretsArgs) -> SecretsConfig:
    json_str = evaluate_config_raw(args)

    try:
        subprocess.run(
            ["jv", schema_path, "-"],
            input=json_str,
            capture_output=True,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise SecretsError(f"Config validation error:\n{e.stdout}")

    return SecretsConfig.from_json(json.loads(json_str))


def evaluate_config_raw(args: SecretsArgs) -> Any:
    if args.json is not None:
        try:
            with open(args.json) as f:
                return f.read()
        except json.decoder.JSONDecodeError as e:
            raise SecretsError(f"Error parsing JSON: {e}")
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
    pkgsDefault = import {nixpkgs_path()} {{}};
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

        return result.stdout
    except subprocess.CalledProcessError as e:
        raise SecretsError(f"Error evaluating nix expression:\n{e.stderr}")


@functools.cache
def nixpkgs_path() -> Optional[str]:
    try:
        result = subprocess.run(
            ["nix-instantiate", "--find-file", "nixpkgs"],
            capture_output=True,
            text=True,
            check=True,
        )

        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return None
