from dataclasses import dataclass

from typing import Mapping, List, Any, Set, Self, Optional
from .error import SecretsError
import re


safe_name_regex = re.compile("^[a-zA-Z0-9:_\\.-]+$")


@dataclass
class SecretsPromptBackend:
    name: str
    ask: str

    def from_jsom(name: str, json: Any) -> Self:
        return SecretsPromptBackend(name=name, ask=json["ask"])


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
class SecretsStoreBackend:
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
        return SecretsStoreBackend(
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
    deploy: bool

    def from_jsom(name: str, json: Any) -> Self:
        if safe_name_regex.search(name) is None:
            raise SecretsError(
                f"File '{name}' does not have a valid name. Currently, only alphanumeric characters, dashes, underscores, and dots are allowed."
            )

        return SecretsFile(name=name, deploy=json["deploy"])


@dataclass
class SecretsSecret:
    name: str
    backend: str
    generate: Optional[str]
    dependencies: List[str]
    prompts: Mapping[str, SecretsPrompt]
    files: Mapping[str, SecretsFile]

    def from_jsom(name: str, json: Any) -> Self:
        if safe_name_regex.search(name) is None:
            raise SecretsError(
                f"Secret '{name}' does not have a valid name. Currently, only alphanumeric characters, dashes, underscores, and dots are allowed."
            )

        result = SecretsSecret(
            name=name,
            backend=json["backend"],
            generate=json["generate"],
            dependencies=json["dependencies"],
            prompts={},
            files={},
        )

        for k, v in json["prompts"].items():
            result.prompts[k] = SecretsPrompt.from_jsom(k, v)

        for k, v in json["files"].items():
            result.files[k] = SecretsFile.from_jsom(k, v)

        if not result.files:
            raise SecretsError(f"Secret '{name}' has no associated files")

        if result.generate is None and result.dependencies:
            raise SecretsError(
                f"Secret '{name}' has associated dependencies without a corresponding generator script"
            )

        if result.generate is None and result.prompts:
            raise SecretsError(
                f"Secret '{name}' has associated prompts without a corresponding generator script"
            )

        return result


@dataclass
class SecretsConfig:
    generators: Mapping[str, SecretsSecret]
    storeBackends: Mapping[str, SecretsStoreBackend]
    promptBackends: Mapping[str, SecretsPromptBackend]

    def from_jsom(json: Any) -> Self:
        result = SecretsConfig(generators={}, storeBackends={}, promptBackends={})

        for k, v in json["backends"]["prompt"].items():
            result.promptBackends[k] = SecretsPromptBackend.from_jsom(k, v)

        for k, v in json["backends"]["store"].items():
            result.storeBackends[k] = SecretsStoreBackend.from_jsom(k, v)

        for k, v in json["store"].items():
            result.generators[k] = SecretsSecret.from_jsom(k, v)

        referencedGenerators: Set[str] = set()
        referencedStoreBackends: Set[str] = set()
        referencedPromptBackends: Set[str] = set()

        for name, gen in result.generators.items():
            referencedGenerators.update(gen.dependencies)
            referencedStoreBackends.add(gen.backend)

        for secret in result.generators.values():
            for name, prompt in secret.prompts.items():
                referencedPromptBackends.add(prompt.backend)

        if missingPromptBackends := referencedPromptBackends - set(
            result.promptBackends.keys()
        ):
            missingList = ", ".join(sorted(missingPromptBackends))
            raise SecretsError(
                f"The following prompt backends are referenced but not defined: {missingList}"
            )

        if missingStoreBackends := referencedStoreBackends - set(
            result.storeBackends.keys()
        ):
            missingList = ", ".join(sorted(missingStoreBackends))
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
        backend: SecretsStoreBackend,
        deployed_only: bool = False,
    ) -> List[tuple[str, str]]:
        files = []
        for generator in self.generators.values():
            if generator.backend != backend.name:
                continue

            for file in generator.files.values():
                # Checks that deployed_only implies file.deploy
                if not deployed_only or deployed_only and file.deploy:
                    files.append((generator.name, file.name))

        return files
