from dataclasses import dataclass
from pathlib import Path
from typing import Optional, Any, Self, Mapping, List
from .error import SecretsError


@dataclass
class SecretsArgs:
    file: Optional[Path]
    flake: Optional[str]
    json: Optional[str]
    attr: Optional[str]
    disable_sandbox: bool
    dry_run: bool
    local: Optional[str]  # "deploy" only
    generators: List[str]  # "generate" only
    set: Mapping[str, str]  # "generate" only
    command: str  # gotta figure out how to type this properly
    verbose: str

    def from_dict(d: Mapping[str, Any]) -> Self:
        # This one is only in the dict when the "generate" command is used.
        # I wish we had proper sum types...
        if "generators" not in d:
            d["generators"] = []
        if "local" not in d:
            d["local"] = None

        setArgDict = dict()
        if "set" in d:
            for arg in d["set"]:
                try:
                    key, value = arg.split(",")
                    if key in setArgDict:
                        raise SecretsError(
                            f"Multiple --set arguments received for generator '{key}'"
                        )
                    setArgDict[key] = Path(value)
                except ValueError:
                    raise SecretsError(f"--set expects key=value pairs: '{arg}' given")
        d["set"] = setArgDict

        args = SecretsArgs(**d)

        configSources = []

        if args.file is not None:
            configSources.append(args.file)
        if args.flake is not None:
            configSources.append(args.flake)
        if args.json is not None:
            configSources.append(args.json)

        if len(configSources) != 1:
            raise SecretsError(
                "Precisely one of the --file, --flake, or --json flags must be provided"
            )

        if args.attr and not args.file:
            raise SecretsError("--attr is only supported for --file")

        return args
