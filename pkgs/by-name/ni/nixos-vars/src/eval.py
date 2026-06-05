import json
import subprocess
from pathlib import Path
from typing import Optional, Any
from .error import VarsError
from .args import VarsArgs


def evaluate_config(args: VarsArgs) -> None:
	if args.file is None and args.flake is None:
		raise VarsError("Neither --file nor --flake was specified")
	if args.flake is not None:
		raise VarsError("Flake support is not yet implemented")
	jsonify = Path(__file__).parent / "nix" / "jsonify.nix"
	expr = f"""
import {jsonify} {{
	config = (import {args.file}){"" if args.attr is None else f".{args.attr}"};
	pkgs = import {"<nixpkgs>" if args.nixpkgs is None else args.nixpkgs} {{}};
}}
"""

	print(expr)

	try:
		result = subprocess.run(
			["nix-instantiate", "--eval", "--json", "--strict", "-E", expr],
			capture_output=True,
			text=True,
			check=True,
		)
		data: Any = json.loads(result.stdout)
		print(data)
	except subprocess.CalledProcessError as e:
		raise VarsError(f"Error evaluating nix expression:\n{e.stderr}")
	pass


#
# 	gen_to_backend: dict[str, str] = {}
# 	backend_objects: dict[str, Backend] = {}
# 	for backend_name, backend_config in data.get("backends", {}).items():
# 		gen_keys = list(backend_config.get("generators", {}).keys())
# 		for gen in gen_keys:
# 			gen_to_backend[gen] = backend_name
# 		backend_config["generators"] = set(gen_keys)
# 		backend_objects[backend_name] = Backend(backend_name, backend_config)
#
# 	return VarsConfig(
# 		generators=data.get("generators", {}),
# 		backends=backend_objects,
# 		gen_to_backend=gen_to_backend,
# 	)
