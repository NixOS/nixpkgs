import subprocess
import graphlib
import functools
from typing import List, Set
from pathlib import Path
from .config import VarsConfig, VarsGeneratorBackend, VarsGenerator, VarsFile
from .error import VarsError


@functools.cache
def build_binary(path: Path) -> Path:
	try:
		result = subprocess.run(
			["nix-store", "--realise", path],
			capture_output=True,
			text=True,
			check=True,
		)

		return result.stdout.strip()
	except subprocess.CalledProcessError as e:
		raise VarsError(f"Error building '{path}':\n{e.stderr}")


def file_exists(
	backend: VarsGeneratorBackend, generator: VarsGenerator, file: VarsFile
) -> bool:
	binary = build_binary(backend.exists)
	result = subprocess.run(
		[binary, generator.name, file.name],
		capture_output=True,
		text=True,
	)

	if result.returncode == 42:
		return False

	try:
		result.check_returncode()
		return True
	except subprocess.CalledProcessError as e:
		raise VarsError(
			f"Error running the '{backend.name}/exists' script for '{generator.name}/{file.name}' [Exit code: {e.returncode}]:\n{e.stderr}"
		)


def get_secret(
	config: VarsConfig, generator: VarsGenerator, file: VarsFile, out: Path
):
	backend = config.generatorBackends[generator.backend]
	binary = build_binary(backend.get)
	try:
		subprocess.run(
			[binary, generator.name, file.name],
			capture_output=True,
			text=True,
			check=True,
			env={"out": out},
		)
	except subprocess.CalledProcessError as e:
		raise VarsError(
			f"Error getting secret '{generator.name}/{file.name}' via the '{backend.name}' backend:\n{e.stderr}"
		)


def set_secret(
	config: VarsConfig, generator: VarsGenerator, file: VarsFile, at: Path
):
	backend = config.generatorBackends[generator.backend]
	binary = build_binary(backend.set)
	try:
		subprocess.run(
			[binary, generator.name, file.name],
			capture_output=True,
			text=True,
			check=True,
			env={"in": at},
		)
	except subprocess.CalledProcessError as e:
		raise VarsError(
			f"Error setting secret '{generator.name}/{file.name}' via the '{backend.name}' backend:\n{e.stderr}"
		)


# NOTE: we take strings here instead of proper VarsBackend/VarsFile object since
# the secrets to be deleted might no longer exist in the configuration (e.g.
# while garbage collecting).
def delete_secret(
	config: VarsConfig,
	backend: VarsGeneratorBackend,
	gen_name: str,
	file_name: str,
):
	binary = build_binary(backend.delete)
	try:
		subprocess.run(
			[binary, gen_name, file_name],
			capture_output=True,
			text=True,
			check=True,
		)
	except subprocess.CalledProcessError as e:
		raise VarsError(
			f"Error deleting secret '{gen_name}/{file_name}' via the '{backend.name}' backend:\n{e.stderr}"
		)


def list_secrets(
	config: VarsConfig, backend: VarsGeneratorBackend
) -> Set[tuple[str, str]]:
	binary = build_binary(backend.list)
	try:
		pairs = set()
		result = subprocess.run(
			[binary],
			capture_output=True,
			text=True,
			check=True,
		)

		for line in result.stdout.strip().split("\n"):
			if not line:
				continue

			parts = line.strip().split()
			if len(parts) == 2:
				pairs.add((parts[0], parts[1]))
			else:
				raise VarsError(
					f"Malformed output for list script in backend '{backend.name}': {line}"
				)

		return pairs
	except subprocess.CalledProcessError as e:
		raise VarsError(
			f"Error listing secrets for the '{backend.name}' backend:\n{e.stderr}"
		)


def execution_order(config: VarsConfig) -> List[str]:
	ts = graphlib.TopologicalSorter()

	for name, gen in config.generators.items():
		ts.add(name, *gen.dependencies)

	try:
		return list(ts.static_order())
	except Exception as e:
		raise VarsError(f"Dependency cycle detected in configuration:\n{e}")


# Returns a sublist of execution_order which only contains the generators
# that need to be rebuilt.
def rebuild_order(config: VarsConfig) -> List[str]:
	order = []

	print("Rebuild order:")
	for item in execution_order(config):
		generator = config.generators[item]

		for dep in generator.dependencies:
			if dep in order:
				print(f"- '{item}' (dependency '{dep}' has changed)")
				order.append(item)
				break
		else:
			for file in generator.files.values():
				backend = config.generatorBackends[generator.backend]
				if not file_exists(backend, generator, file):
					print(f"- '{item}' (file '{file.name}' is missing)")
					order.append(item)
					break
			else:
				print(f"- Skipping '{item}'")

	return order
