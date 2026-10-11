import json
import shlex
from collections.abc import Mapping
from typing import Protocol


class TestMachine(Protocol):
    def succeed(self, command: str, /) -> str: ...

    def wait_for_unit(self, unit: str, /) -> None: ...

    def wait_for_open_port(self, port: int, /) -> None: ...

    def wait_until_succeeds(self, command: str, timeout: int = 900) -> str: ...


def api_command(path: str) -> str:
    return "curl --fail --silent --show-error -H @/tmp/api-header " + shlex.quote(
        "http://127.0.0.1:5000/api/v1/" + path
    )


def api(machine: TestMachine, path: str, data: Mapping[str, object] | None = None) -> str:
    command = api_command(path)
    if data is not None:
        command += " -H 'Content-Type: application/json' --data " + shlex.quote(
            json.dumps(data)
        )
    return machine.succeed(command)


def wait_for_service(machine: TestMachine, version: str) -> None:
    machine.wait_for_unit("changedetection-io.service")
    machine.wait_for_open_port(5000)
    _ = machine.wait_until_succeeds(
        "curl --fail --silent http://127.0.0.1:5000/ > /tmp/homepage"
    )
    _ = machine.succeed("grep -F " + shlex.quote(version) + " /tmp/homepage")
    _ = machine.succeed(
        "umask 077; jq -r '\"x-api-key: \" + .settings.application.api_access_token' "
        + "/var/lib/changedetection-io/changedetection.json > /tmp/api-header"
    )


def wait_for_snapshot(
    machine: TestMachine, watch: str, content: str, timeout: int = 900
) -> None:
    _ = machine.wait_until_succeeds(
        api_command(f"watch/{watch}/history/latest")
        + " | grep -F "
        + shlex.quote(content),
        timeout=timeout,
    )
