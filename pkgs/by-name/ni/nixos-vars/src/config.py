from dataclasses import dataclass
from typing import Mapping, List, Any, Set, Self
from graphlib import TopologicalSorter
from .error import VarsError


@dataclass
class VarsPromptBackend:
	script: str

	def fromJSON(json: Any) -> Self:
		return VarsPromptBackend(json["script"])


@dataclass
class VarsPrompt:
	description: str
	backend: str
	type: str  # There's probably a way to type this properly..

	def fromJSON(json: Any) -> Self:
		return VarsPrompt(json["description"], json["backend"], json["type"])


@dataclass
class VarsGeneratorBackend:
	get: str
	set: str
	exists: str
	delete: str
	list: str
	deploy: str
	deployLocal: str

	def fromJSON(json: Any) -> Self:
		return VarsGeneratorBackend(
			json["get"],
			json["set"],
			json["exists"],
			json["delete"],
			json["list"],
			json["deploy"],
			json["deployLocal"],
		)


@dataclass
class VarsFile:
	name: str
	deploy: bool
	secret: bool

	def fromJSON(json: Any) -> Self:
		return VarsFile(json["name"], json["deploy"], json["secret"])


@dataclass
class VarsGenerator:
	backend: str
	script: str
	dependencies: List[str]
	prompts: List[str]
	files: List[VarsFile]

	def fromJSON(json: Any) -> Self:
		result = VarsGenerator(
			json["backend"],
			json["script"],
			json["dependencies"],
			json["prompts"],
			[],
		)

		for file in json["files"].values():
			result.files.append(VarsFile.fromJSON(file))

		return result


@dataclass
class VarsConfig:
	prompts: Mapping[str, VarsPrompt]
	promptBackends: Mapping[str, VarsPromptBackend]

	generators: Mapping[str, VarsGenerator]
	generatorBackends: Mapping[str, VarsGeneratorBackend]

	def fromJSON(json: Any) -> Self:
		result = VarsConfig({}, {}, {}, {})

		for k, v in json["prompts"].items():
			result.prompts[k] = VarsPrompt.fromJSON(v)

		for k, v in json["promptBackends"].items():
			result.promptBackends[k] = VarsPromptBackend.fromJSON(v)

		for k, v in json["generators"].items():
			result.generators[k] = VarsGenerator.fromJSON(v)

		for k, v in json["generatorBackends"].items():
			result.generatorBackends[k] = VarsGeneratorBackend.fromJSON(v)

		missingPrompts: Set[str] = set()
		promptNames = set(result.prompts.keys())

		missingDependencies: Set[str] = set()
		dependencyNames = set(result.generators.keys())

		for name, gen in result.generators.items():
			missingDependencies.update(set(gen.dependencies) - dependencyNames)
			missingPrompts.update(set(gen.prompts) - promptNames)

		if missingPrompts:
			missingList = ", ".join(sorted(missingPrompts))
			raise VarsError(
				f"The following prompts are referenced but not defined: {missingList}"
			)

		if missingDependencies:
			missingList = ", ".join(sorted(missingDependencies))
			raise VarsError(
				f"The following generators are referenced but not defined: {missingList}"
			)

		return result

	def executionOrder(self) -> List[str]:
		ts = TopologicalSorter()

		for name, gen in self.generators.items():
			ts.add(name, *gen.dependencies)

		try:
			return list(ts.static_order())
		except Exception as e:
			raise VarsError(f"Dependency cycle detected in configuration:\n{e}")
