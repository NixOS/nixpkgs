from dataclasses import dataclass
from typing import Set, Self
from .exec import list_secrets
from .config import SecretsConfig
from .args import SecretsArgs


# This is a workaround around the fact that tuples are not hashable
@dataclass(frozen=True)
class SecretsFileListEntry:
    backend: str
    secret: str
    file: str


@dataclass(frozen=True)
class SecretsFileList:
    entries: Set[SecretsFileListEntry]

    def has(
        self: Self,
        backend: str,
        secret: str,
        file: str,
    ) -> bool:
        return (
            SecretsFileListEntry(backend=backend, secret=secret, file=file)
            in self.entries
        )


def build_file_list(args: SecretsArgs, config: SecretsConfig) -> SecretsFileList:
    entries: Set[SecretsFileListEntry] = set()
    for backend in config.storeBackends.values():
        for secret, file in list_secrets(args, config, backend):
            entries.add(SecretsFileListEntry(backend.name, secret, file))
    return SecretsFileList(entries)
