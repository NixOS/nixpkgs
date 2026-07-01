from dataclasses import dataclass
from typing import Mapping, List, Any, Set, Self
from .error import VarsError


@dataclass
class VarsPromptBackend:
	script: str

	def from_jsom(json: Any) -> Self:
		return VarsPromptBackend(script=json["script"])


@dataclass
class VarsPrompt:
	description: str
	backend: str
	type: str  # There's probably a way to type this properly..

	def from_jsom(json: Any) -> Self:
		return VarsPrompt(
			description=json["description"],
			backend=json["backend"],
			type=json["type"],
		)


@dataclass
class VarsGeneratorBackend:
	get: str
	set: str
	exists: str
	delete: str
	list: str
	deploy: str
	deployLocal: str

	def from_jsom(json: Any) -> Self:
		return VarsGeneratorBackend(
			get=json["get"],
			set=json["set"],
			exists=json["exists"],
			delete=json["delete"],
			list=json["list"],
			deploy=json["deploy"],
			deployLocal=json["deployLocal"],
		)


@dataclass
class VarsFile:
	name: str
	deploy: bool
	secret: bool

	def from_jsom(json: Any) -> Self:
		return VarsFile(
			name=json["name"], deploy=json["deploy"], secret=json["secret"]
		)


@dataclass
class VarsGenerator:
	name: str
	backend: str
	script: str
	dependencies: List[str]
	prompts: List[str]
	files: List[VarsFile]

	def from_jsom(name: str, json: Any) -> Self:
		result = VarsGenerator(
			name=name,
			backend=json["backend"],
			script=json["script"],
			dependencies=json["dependencies"],
			prompts=json["prompts"],
			files=[],
		)

		for file in json["files"].values():
			result.files.append(VarsFile.from_jsom(file))

		return result


@dataclass
class VarsConfig:
	prompts: Mapping[str, VarsPrompt]
	promptBackends: Mapping[str, VarsPromptBackend]

	generators: Mapping[str, VarsGenerator]
	generatorBackends: Mapping[str, VarsGeneratorBackend]

	def from_jsom(json: Any) -> Self:
		result = VarsConfig({}, {}, {}, {})

		for k, v in json["prompts"].items():
			result.prompts[k] = VarsPrompt.from_jsom(v)

		for k, v in json["promptBackends"].items():
			result.promptBackends[k] = VarsPromptBackend.from_jsom(v)

		for k, v in json["generators"].items():
			result.generators[k] = VarsGenerator.from_jsom(k, v)

		for k, v in json["generatorBackends"].items():
			result.generatorBackends[k] = VarsGeneratorBackend.from_jsom(v)

		referencedPrompts: Set[str] = set()
		referencedGenerators: Set[str] = set()
		referencedGeneratorBackends: Set[str] = set()
		referencedPromptBackends: Set[str] = set()

		for name, gen in result.generators.items():
			referencedGenerators.update(gen.dependencies)
			referencedPrompts.update(gen.prompts)
			referencedGeneratorBackends.add(gen.backend)

		for name, prompt in result.prompts.items():
			referencedPromptBackends.add(prompt.backend)

		if missingPromptBackends := referencedPromptBackends - set(
			result.promptBackends.keys()
		):
			missingList = ", ".join(sorted(missingPromptBackends))
			raise VarsError(
				f"The following prompt backends are referenced but not defined: {missingList}"
			)

		if missingPrompts := referencedPrompts - set(result.prompts.keys()):
			missingList = ", ".join(sorted(missingPrompts))
			raise VarsError(
				f"The following prompts are referenced but not defined: {missingList}"
			)

		if missingGeneratorBackends := referencedGeneratorBackends - set(
			result.generators.keys()
		):
			missingList = ", ".join(sorted(missingGeneratorBackends))
			raise VarsError(
				f"The following generator backends are referenced but not defined: {missingList}"
			)

		if missingGenerators := referencedGenerators - set(
			result.generators.keys()
		):
			missingList = ", ".join(sorted(missingGenerators))
			raise VarsError(
				f"The following generators are referenced but not defined: {missingList}"
			)

		return result
