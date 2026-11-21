"""systemd helpers for Linux guests."""

import datetime as dt
import shlex

from test_driver.duration import Duration
from test_driver.errors import MachineError, RequestedAssertionFailed

from image_test_driver.machine.base import BaseMachine


class _MachineProtocol(BaseMachine):
    """A typing aid: the parts of `BaseMachine` the mixins use."""


class SystemdMachine(_MachineProtocol):
    """systemd helpers, for Linux guests."""

    async def systemctl(self, query: str, user: str | None = None) -> tuple[int, str]:
        if user is None:
            return await self.execute(f"systemctl {query}")
        quoted = shlex.quote(query)
        return await self.execute(
            f"XDG_RUNTIME_DIR=/run/user/$(id -u {user}) "
            f"su -l {user} -c 'systemctl --user {quoted}'"
        )

    async def wait_for_unit(
        self,
        unit: str,
        *,
        deadline: Duration = dt.timedelta(minutes=15),
    ) -> None:
        await self.wait_until_succeeds(
            f"systemctl is-active --quiet {shlex.quote(unit)}", deadline=deadline
        )

    async def require_unit_state(
        self, unit: str, require_state: str = "active"
    ) -> None:
        status, output = await self.execute(
            f"systemctl show --property=ActiveState --value {shlex.quote(unit)}"
        )
        if status != 0:
            raise MachineError(f"{self.name}: cannot query unit {unit}")
        state = output.strip()
        if state != require_state:
            raise RequestedAssertionFailed(
                f"Expected unit '{unit}' to be in state '{require_state}' "
                f"but it is in state '{state}'"
            )

    async def start_job(self, jobname: str, user: str | None = None) -> tuple[int, str]:
        return await self.systemctl(f"start {jobname}", user)

    async def stop_job(self, jobname: str, user: str | None = None) -> tuple[int, str]:
        return await self.systemctl(f"stop {jobname}", user)
