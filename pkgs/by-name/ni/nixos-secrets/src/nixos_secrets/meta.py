import json
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Self

from .args import SecretsArgs
from .config import (
    SecretsConfig,
    SecretsFile,
    SecretsSecret,
    meta_file_name,
)
from .error import SecretsError
from .exec import get_secret, set_secret
from .list import SecretsFileList

VersionID = str


@dataclass(frozen=True)
class SecretsMetadata:
    id: VersionID
    dependencies: dict[str, VersionID]

    @staticmethod
    def from_json(json: Any) -> "SecretsMetadata":
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
) -> SecretsMetadata | None:
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
