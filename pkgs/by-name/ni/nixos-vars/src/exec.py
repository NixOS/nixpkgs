import subprocess
import graphlib
import functools
from typing import List
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
		raise VarsError(f"Error building {path}:\n{e.stderr}")


def file_exists(
	backend: VarsGeneratorBackend, generator: VarsGenerator, file: VarsFile
) -> bool:
	binary = build_binary(backend.exists)
	result = subprocess.run(
		[binary, generator.name, file.name],
		capture_output=True,
		text=True,
	)
	return result.returncode == 0


def get_secret(
	config: VarsConfig, generator: VarsGenerator, file: VarsFile, out: Path
):
	backend = config.generatorBackends[generator.backend]
	binary = build_binary(backend.get)
	subprocess.run(
		[binary, generator.name, file.name],
		capture_output=True,
		text=True,
		check=True,
		env={"out": out},
	)


def set_secret(
	config: VarsConfig, generator: VarsGenerator, file: VarsFile, at: Path
):
	backend = config.generatorBackends[generator.backend]
	binary = build_binary(backend.set)
	subprocess.run(
		[binary, generator.name, file.name],
		capture_output=True,
		text=True,
		check=True,
		env={"in": at},
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
				print(f"- '{item}' (dependency '{dep}' changed)")
				order.append(item)
				break
		else:
			for file in generator.files:
				backend = config.generatorBackends[generator.backend]
				if not file_exists(backend, generator, file):
					print(f"- '{item}' (file '{file.name}' is missing)")
					order.append(item)
					break
			else:
				print(f"- Skipping '{item}'")

	return order
