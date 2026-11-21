"""Driver configuration, loaded from the JSON the Nix expression represents."""

import datetime as dt
import json
from pathlib import Path
from typing import Any, Literal

from pydantic import BaseModel, Field


class MachineConfiguration(BaseModel):
    name: str
    backend: Literal["qemu", "tart"]
    image: str
    cpus: int = 2
    memory: str = "2G"
    boot: Literal["efi", "mbr"] = "efi"
    snapshot: bool = False
    networking: bool = False
    credentials: dict[str, str] = Field(default_factory=dict)
    cloud_init: dict[str, Any] | None = None
    boot_timeout: float = 120.0


class DriverConfiguration(BaseModel):
    machines: dict[str, MachineConfiguration]
    global_timeout: dt.timedelta
    test_script: Path


def load(path: str | Path) -> DriverConfiguration:
    with open(path) as handle:
        return DriverConfiguration.model_validate(json.load(handle))
