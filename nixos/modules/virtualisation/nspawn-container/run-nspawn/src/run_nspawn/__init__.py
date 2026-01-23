import contextlib
import dataclasses
import fcntl
import logging
import os
import signal
import subprocess
import sys
import typing
from pathlib import Path

logger = logging.getLogger()

# Install a SIGTERM handler so all our context managers get a chance to
# clean up.
signal.signal(signal.SIGTERM, lambda _signum, _frame: sys.exit(0))


@dataclasses.dataclass
class Netns:
    name: str
    path: Path


def run_ip(*args: str) -> None:
    subprocess.run(
        ["@ip@", *args],
        check=True,
    )


@contextlib.contextmanager
def mk_netns(name: str) -> typing.Generator[Netns, None, None]:
    logger.info("creating netns %s", name)
    run_ip("netns", "add", name)
    try:
        yield Netns(name=name, path=Path("/run/netns") / name)
    finally:
        logger.info("deleting netns %s", name)
        run_ip("netns", "delete", name)


@contextlib.contextmanager
def vlan_lock(vlan: int) -> typing.Generator[None, None, None]:
    lockfile = Path(f"/run/nixos-nspawn/vlan-{vlan}.lock")
    lockfile.parent.mkdir(parents=True, exist_ok=True)
    with lockfile.open("w") as f:
        # Grab an exclusive lock.
        fcntl.flock(f, fcntl.LOCK_EX)
        try:
            yield
        finally:
            # Release the exclusive lock.
            fcntl.flock(f, fcntl.LOCK_UN)


@contextlib.contextmanager
def ensure_vlan_bridge(vlan: int) -> typing.Generator[str, None, None]:
    """
    Ensure a bridge for the given vlan exists, and create one if it does not.

    Note that this bridge may get used by other containers, so we're careful
    to not delete it unless we're sure nobody else is using it.
    """
    # These IP addresses correspond to the static IP assignment logic in
    # <nixos/lib/testing/network.nix>.
    ipv4_addr = f"192.168.{vlan}.254/24"
    ipv6_addr = f"2001:db8:{vlan}::fe/64"

    bridge_name = f"br{vlan}"
    bridge_path = Path("/sys/class/net") / bridge_name
    try:
        # To avoid racing against other nspawn containers that also
        # need this vlan, grab an exclusive lock.
        with vlan_lock(vlan):
            if not bridge_path.exists():
                logger.info("creating bridge %s", bridge_name)
                run_ip("link", "add", bridge_name, "type", "bridge")
                run_ip("link", "set", bridge_name, "up")
                run_ip("addr", "add", ipv4_addr, "dev", bridge_name)
                run_ip("addr", "add", ipv6_addr, "dev", bridge_name)

        yield bridge_name
    finally:
        # To avoid racing against other nspawn containers that also
        # releasing this vlan, grab an exclusive lock.
        with vlan_lock(vlan):
            if bridge_path.exists():
                child_intf_count = len(list((bridge_path / "brif").iterdir()))
                if child_intf_count == 0:
                    logger.info("deleting bridge %s", bridge_name)
                    run_ip("link", "delete", bridge_name)


@contextlib.contextmanager
def mk_veth(
    container_name: str,
    netns: Netns,
    container_intf_name: str,
    vlan: int,
) -> typing.Generator[None, None, None]:
    host_intf_name = f"{container_name}-{container_intf_name}"
    with ensure_vlan_bridge(vlan) as bridge_name:
        logger.info("creating interface %s", host_intf_name)
        run_ip(
            "link",
            "add",
            host_intf_name,
            "type",
            "veth",
            "peer",
            "name",
            container_intf_name,
            "netns",
            netns.name,
        )
        try:
            run_ip("link", "set", host_intf_name, "master", bridge_name)
            run_ip("link", "set", host_intf_name, "up")
            yield
        finally:
            logger.info("deleting interface %s", host_intf_name)
            run_ip("link", "delete", host_intf_name)


def run(
    container_name: str,
    root_dir_str: str,
    interfaces: dict,
    nspawn_options: list[str],
    init: str,
    cmdline: list[str],
) -> None:
    logging.basicConfig(
        format=f"nixos-nspawn({container_name}): %(message)s",
        level=logging.WARNING,
    )

    assert os.geteuid() == 0, (
        f"systemd-nspawn requires root to work. You are {os.geteuid()}"
    )

    root_dir = Path(root_dir_str)

    root_dir.mkdir(parents=True, exist_ok=True)
    root_dir.chmod(0o755)

    with (
        mk_netns(f"nixos-nspawn-{container_name}") as netns,
        contextlib.ExitStack() as stack,
    ):
        for interface in interfaces:
            stack.enter_context(
                mk_veth(
                    container_name=container_name,
                    netns=netns,
                    container_intf_name=interface["name"],
                    vlan=interface["vlan"],
                )
            )

        def print_pid() -> None:
            print(
                f"systemd-nspawn's PID is {os.getpid()}",
                # Need to flush stdout before systemd-nspawn gets exec-ed.
                flush=True,
            )

        cp = subprocess.Popen(
            [
                "@systemd-nspawn@",
                *nspawn_options,
                f"--directory={root_dir}",
                f"--network-namespace-path={netns.path}",
                init,
                *cmdline,
            ],
            preexec_fn=print_pid,
        )

        try:
            exit_code = cp.wait()
        finally:
            # If we get interrupted for any reason (most likely a SIGTERM),
            # be sure to kill our child process.
            cp.terminate()

            # NixOS creates `/var/empty` with the immutable filesystem attribute [0].
            # This makes it difficult to clean up the machine's root directory
            # (which the test driver does to ensure tests start fresh).
            # We unset that bit here so others are less likely to run into this issue.
            # Note: this may cause issues on filesystems that don't support
            # "Linux file attributes". Please improve this if you run into this!
            #
            # [0]: https://github.com/NixOS/nixpkgs/blob/d1eff395720e1fe15838263642a2bc1dca1eea32/nixos/modules/system/activation/activation-script.nix#L281
            subprocess.run(
                [
                    "@chattr@",
                    "-i",
                    root_dir / "var/empty",
                ],
                check=True,
            )

        sys.exit(exit_code)


def main():
    import argparse
    import json

    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument(
        "--container-name", required=True, help="Name of the container"
    )
    arg_parser.add_argument(
        "--root-dir",
        required=True,
        help="Path to container root directory (overridable with RUN_NSPAWN_ROOT_DIR)",
    )
    arg_parser.add_argument(
        "--interfaces-json",
        dest="interfaces",
        type=json.loads,
        required=True,
        help="JSON-encoded list of interfaces, each with 'name' and 'vlan' fields",
    )
    arg_parser.add_argument("--init", required=True, help="Path to init binary")
    arg_parser.add_argument(
        "--cmdline-json",
        dest="cmdline",
        type=json.loads,
        default=[],
        help="JSON-encoded list of command line arguments to pass to init",
    )
    # Parse only known args to allow for extra args to be passed to systemd-nspawn.
    args, nspawn_options = arg_parser.parse_known_args()

    run(
        container_name=args.container_name,
        root_dir_str=os.getenv("RUN_NSPAWN_ROOT_DIR", default=args.root_dir),
        interfaces=args.interfaces,
        nspawn_options=nspawn_options,
        init=args.init,
        cmdline=args.cmdline,
    )


if __name__ == "__main__":
    main()
