import tempfile
import json
from dataclasses import dataclass
from typing import Any, Mapping, Self, Optional
from pathlib import Path

from .error import SecretsError
from .args import SecretsArgs
from .exec import get_secret, set_secret
from .list import SecretsFileList
from .config import (
    SecretsConfig,
    SecretsSecret,
    SecretsFile,
    meta_file_name,
)

VersionID = str


@dataclass(frozen=True)
class SecretsMetadata:
    id: VersionID
    dependencies: Mapping[str, VersionID]

    def from_json(json: Any) -> Self:
        return SecretsMetadata(id=json["id"], dependencies=json["dependencies"])

    def to_json(self: Self):
        return {
            "version": 1,  # Future proofing
            "id": self.id,
            "dependencies": self.dependencies,
        }


def get_meta(
    args: SecretsArgs,
    config: SecretsConfig,
    files: SecretsFileList,
    secret: SecretsSecret,
) -> Optional[SecretsMetadata]:
    if not files.has(secret.backend, secret.name, meta_file_name):
        return None

    meta_file = SecretsFile(name=meta_file_name)
    with tempfile.NamedTemporaryFile(mode="r") as file:
        out_path = Path(file.name)

        try:
            get_secret(args, config, secret, meta_file, out_path)
        except SecretsError:
            return None

        try:
            raw = json.loads(file.read())
            return SecretsMetadata.from_json(raw)
        except json.decoder.JSONDecodeError as e:
            raise SecretsError(f"Error parsing metadata: {e}")


def set_meta(
    args: SecretsArgs,
    config: SecretsConfig,
    secret: SecretsSecret,
    meta: SecretsMetadata,
):
    with tempfile.NamedTemporaryFile(mode="w") as file:
        in_path = Path(file.name)
        raw = json.dumps(meta.to_json())
        file.write(raw)
        file.flush()
        set_secret(args, config, secret, SecretsFile(name=meta_file_name), in_path)
