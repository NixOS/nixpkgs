from dataclasses import dataclass
from pathlib import Path
from typing import Any

from .error import SecretsError


@dataclass(frozen=True)
class SecretsArgs:
    file: Path | None
    flake: str | None
    json: str | None
    attr: str | None
    disable_sandbox: bool
    dry_run: bool
    local: str | None  # "deploy" only
    generators: list[str]  # "generate" only
    timeout: float | None  # "generate" only
    command: str  # gotta figure out how to type this properly
    secret_name: str | None  # "from-file"/"edit" only
    secret_file: str | None # "from-file"/"edit" only
    secret_path: Path | None  # "from-file" only
    verbose: str

    @staticmethod
    def from_dict(d: dict[str, Any]) -> "SecretsArgs":
        # I really wish I had some kind of proper sum types for this ugh...
        # Having all the fields in a flat struct feels kinda bad :/
        if "generators" not in d:
            d["generators"] = []
        if "local" not in d:
            d["local"] = None
        if "timeout" not in d:
            d["timeout"] = None
        if "secret_name" not in d:
            d["secret_name"] = None
        if "secret_file" not in d:
            d["secret_file"] = None
        if "secret_path" not in d:
            d["secret_path"] = None

        args = SecretsArgs(**d)

        configSources: list[str] = []
        if args.file is not None:
            configSources.append(str(args.file))
        if args.flake is not None:
            configSources.append(args.flake)
        if args.json is not None:
            configSources.append(str(args.json))

        if len(configSources) != 1:
            raise SecretsError(
                "Precisely one of the --file, --flake, or --json flags must be provided"
            )

        if args.attr and not args.file:
            raise SecretsError("--attr is only supported for --file")

        return args
