import datetime as dt
import json
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, Field

DisplayBackend = Literal["x11"]
DisplayProtocol = Literal["vnc"]


class X11DisplayTargetConfiguration(BaseModel):
    backend: DisplayBackend
    display: str = ":0"
    xauthority: Path = Path("/root/.Xauthority")


DisplayTargetConfiguration = X11DisplayTargetConfiguration


class VncDisplayViewerConfiguration(BaseModel):
    kind: Literal["vnc"]
    executable: Path


DisplayViewerConfiguration = VncDisplayViewerConfiguration


class NspawnX11VncExporterConfiguration(BaseModel):
    kind: Literal["x11-vnc"]
    server: Path
    relay: Path


NspawnDisplayExporterConfiguration = NspawnX11VncExporterConfiguration


class MachineConfiguration(BaseModel):
    name: str
    start_script: Path


class QemuMachineConfiguration(MachineConfiguration):
    pass


class NspawnMachineConfiguration(MachineConfiguration):
    display_targets: list[DisplayTargetConfiguration] = Field(default_factory=list)
    display_exporters: dict[DisplayBackend, NspawnDisplayExporterConfiguration] = Field(
        default_factory=dict
    )


class DriverConfiguration(BaseModel):
    vms: dict[str, QemuMachineConfiguration]
    containers: dict[str, NspawnMachineConfiguration]
    display_viewers: dict[DisplayProtocol, DisplayViewerConfiguration] = Field(
        default_factory=dict
    )
    vlans: list[int]
    global_timeout: dt.timedelta
    enable_ssh_backdoor: bool
    test_script: Path


def load_driver_configuration(file_path: str) -> DriverConfiguration:
    with open(file_path) as file:
        data = json.load(file)
    return DriverConfiguration.model_validate(data)
