from dataclasses import dataclass
from typing import Mapping, List, Any, Set, Self, Optional
from .error import VarsError


@dataclass
class VarsPromptBackend:
    name: str
    script: str

    def from_jsom(name: str, json: Any) -> Self:
        return VarsPromptBackend(name=name, script=json["script"])


@dataclass
class VarsPrompt:
    name: str
    label: str
    description: Optional[str]
    backend: str
    type: str  # There's probably a way to type this properly..

    def from_jsom(name: str, json: Any) -> Self:
        return VarsPrompt(
            name=name,
            label=json["label"],
            description=json["description"],
            backend=json["backend"],
            type=json["type"],
        )


@dataclass
class VarsGeneratorBackend:
    name: str
    get: Optional[str]
    set: str
    exists: str
    delete: Optional[str]
    list: Optional[str]
    fixup: Optional[str]
    deployRemote: Optional[str]
    deployLocal: Optional[str]

    def from_jsom(name: str, json: Any) -> Self:
        return VarsGeneratorBackend(
            name=name,
            get=json["get"],
            set=json["set"],
            exists=json["exists"],
            delete=json.get("delete"),
            list=json.get("list"),
            fixup=json.get("fixup"),
            deployRemote=json["deploy"].get("remote"),
            deployLocal=json["deploy"].get("local"),
        )


@dataclass
class VarsFile:
    name: str
    local: bool

    def from_jsom(name: str, json: Any) -> Self:
        return VarsFile(name=name, local=json["local"])


@dataclass
class VarsGenerator:
    name: str
    backend: str
    script: str
    dependencies: List[str]
    prompts: List[str]
    files: Mapping[str, VarsFile]

    def from_jsom(name: str, json: Any) -> Self:
        result = VarsGenerator(
            name=name,
            backend=json["backend"],
            script=json["script"],
            dependencies=json["dependencies"],
            prompts=json["prompts"],
            files={},
        )

        for k, v in json["files"].items():
            result.files[k] = VarsFile.from_jsom(k, v)

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
            result.prompts[k] = VarsPrompt.from_jsom(k, v)

        for k, v in json["promptBackends"].items():
            result.promptBackends[k] = VarsPromptBackend.from_jsom(k, v)

        for k, v in json["generators"].items():
            result.generators[k] = VarsGenerator.from_jsom(k, v)

        for k, v in json["generatorBackends"].items():
            result.generatorBackends[k] = VarsGeneratorBackend.from_jsom(k, v)

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
            result.generatorBackends.keys()
        ):
            missingList = ", ".join(sorted(missingGeneratorBackends))
            raise VarsError(
                f"The following generator backends are referenced but not defined: {missingList}"
            )

        if missingGenerators := referencedGenerators - set(result.generators.keys()):
            missingList = ", ".join(sorted(missingGenerators))
            raise VarsError(
                f"The following generators are referenced but not defined: {missingList}"
            )

        return result

    def files_for_backend(
        self: Self,
        backend: VarsGeneratorBackend,
        no_local: bool = False,
    ) -> List[tuple[str, str]]:
        files = []
        for generator in self.generators.values():
            if generator.backend != backend.name:
                continue

            for file in generator.files.values():
                if no_local and file.local:
                    files.append((generator.name, file.name))

        return files
