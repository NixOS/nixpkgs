import datetime as dt
import json
from pathlib import Path

from pydantic import BaseModel


class MachineConfiguration(BaseModel):
    name: str
    start_script: Path


class QemuMachineConfiguration(MachineConfiguration):
    pass


class NspawnMachineConfiguration(MachineConfiguration):
    pass


class DriverConfiguration(BaseModel):
    vms: dict[str, QemuMachineConfiguration]
    containers: dict[str, NspawnMachineConfiguration]
    vlans: list[int]
    global_timeout: dt.timedelta
    enable_ssh_backdoor: bool
    test_script: Path


def load_driver_configuration(file_path: str) -> DriverConfiguration:
    with open(file_path) as file:
        data = json.load(file)
    return DriverConfiguration.model_validate(data)
