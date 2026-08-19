from dataclasses import dataclass

from typing import Mapping, List, Any, Set, Self, Optional
from .error import SecretsError
import re


safe_name_regex = re.compile("^[a-zA-Z0-9:_\\.-]*$")


@dataclass
class SecretsPromptBackend:
    name: str
    script: str

    def from_jsom(name: str, json: Any) -> Self:
        return SecretsPromptBackend(name=name, script=json["script"])


@dataclass
class SecretsPrompt:
    name: str
    label: str
    description: Optional[str]
    backend: str
    type: str  # There's probably a way to type this properly..

    def from_jsom(name: str, json: Any) -> Self:
        return SecretsPrompt(
            name=name,
            label=json["label"],
            description=json["description"],
            backend=json["backend"],
            type=json["type"],
        )


@dataclass
class SecretsGeneratorBackend:
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
        return SecretsGeneratorBackend(
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
class SecretsFile:
    name: str
    local: bool

    def from_jsom(name: str, json: Any) -> Self:
        if safe_name_regex.search(name) is None:
            raise SecretsError(
                f"File '{name}' does not have a valid name. Currently, only alphanumeric characters, dashes, underscores, and dots are allowed."
            )

        return SecretsFile(name=name, local=json["local"])


@dataclass
class SecretsGenerator:
    name: str
    backend: str
    script: str
    dependencies: List[str]
    prompts: List[str]
    files: Mapping[str, SecretsFile]

    def from_jsom(name: str, json: Any) -> Self:
        if safe_name_regex.search(name) is None:
            raise SecretsError(
                f"Generator '{name}' does not have a valid name. Currently, only alphanumeric characters, dashes, underscores, and dots are allowed."
            )

        result = SecretsGenerator(
            name=name,
            backend=json["backend"],
            script=json["script"],
            dependencies=json["dependencies"],
            prompts=json["prompts"],
            files={},
        )

        for k, v in json["files"].items():
            result.files[k] = SecretsFile.from_jsom(k, v)

        return result


@dataclass
class SecretsConfig:
    prompts: Mapping[str, SecretsPrompt]
    promptBackends: Mapping[str, SecretsPromptBackend]

    generators: Mapping[str, SecretsGenerator]
    generatorBackends: Mapping[str, SecretsGeneratorBackend]

    def from_jsom(json: Any) -> Self:
        result = SecretsConfig({}, {}, {}, {})

        for k, v in json["prompts"].items():
            result.prompts[k] = SecretsPrompt.from_jsom(k, v)

        for k, v in json["promptBackends"].items():
            result.promptBackends[k] = SecretsPromptBackend.from_jsom(k, v)

        for k, v in json["generators"].items():
            result.generators[k] = SecretsGenerator.from_jsom(k, v)

        for k, v in json["generatorBackends"].items():
            result.generatorBackends[k] = SecretsGeneratorBackend.from_jsom(k, v)

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
            raise SecretsError(
                f"The following prompt backends are referenced but not defined: {missingList}"
            )

        if missingPrompts := referencedPrompts - set(result.prompts.keys()):
            missingList = ", ".join(sorted(missingPrompts))
            raise SecretsError(
                f"The following prompts are referenced but not defined: {missingList}"
            )

        if missingGeneratorBackends := referencedGeneratorBackends - set(
            result.generatorBackends.keys()
        ):
            missingList = ", ".join(sorted(missingGeneratorBackends))
            raise SecretsError(
                f"The following generator backends are referenced but not defined: {missingList}"
            )

        if missingGenerators := referencedGenerators - set(result.generators.keys()):
            missingList = ", ".join(sorted(missingGenerators))
            raise SecretsError(
                f"The following generators are referenced but not defined: {missingList}"
            )

        return result

    def files_for_backend(
        self: Self,
        backend: SecretsGeneratorBackend,
        no_local: bool = False,
    ) -> List[tuple[str, str]]:
        files = []
        for generator in self.generators.values():
            if generator.backend != backend.name:
                continue

            for file in generator.files.values():
                # Checks that no_local implies !file.local
                if not no_local or no_local and not file.local:
                    files.append((generator.name, file.name))

        return files
