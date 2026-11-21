# Type information prepended to an image test script so that it can be type
# checked and linted.
#
# This mirrors `nixos/lib/test-script-prepend.py` for the NixOS driver.

from typing import Any, cast

from image_test_driver.machine.base import BaseMachine
from image_test_driver.machine.qemu import QemuMachine

machine = cast(QemuMachine, None)
machines = cast("list[BaseMachine]", [])
driver = cast(Any, None)
