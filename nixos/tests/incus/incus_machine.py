import json


class IncusHost(Machine):
    def __init__(self, base):
        with subtest("Wait for startup"):
            base.wait_for_unit("incus.service")
            base.wait_for_unit("incus-preseed.service")

        with subtest("Verify preseed resources created"):
            base.succeed("incus profile show default")
            base.succeed("incus network info incusbr0")
            base.succeed("incus storage show default")

        self._parent = base

    # delegate attribute access to the parent
    def __getattr__(self, name):
        return getattr(self._parent, name)

    def instance_exec(self, name: str, command: str, project: str = "default"):
        return super().execute(
            f"incus exec {name} --disable-stdin --force-interactive --project {project} -- {command}"
        )

    def instance_succeed(self, name: str, command: str, project: str = "default"):
        return super().succeed(
            f"incus exec {name} --disable-stdin --force-interactive --project {project} -- {command}"
        )

    def wait_for_instance(self, name: str, project: str = "default"):
        self.wait_instance_exec_success(
            name,
            "/run/current-system/sw/bin/systemctl is-system-running",
            project=project,
        )

    def wait_instance_exec_success(
        self, name: str, command: str, timeout: int = 900, project: str = "default"
    ):
        def check_command(_) -> bool:
            status, _ = self.instance_exec(name, command, project)
            return status == 0

        with super().nested(
            f"Waiting for successful instance exec, instance={name}, project={project}, command={command}"
        ):
            retry(check_command, timeout)

    def set_instance_config(
        self, name: str, config: str, restart: bool = False, unset: bool = False
    ):
        if restart:
            super().succeed(f"incus stop {name}")

        if unset:
            super().succeed(f"incus config unset {name} {config}")
        else:
            super().succeed(f"incus config set {name} {config}")

        if restart:
            super().succeed(f"incus start {name}")
            self.wait_for_instance(name)
        else:
            # give a moment to settle
            super().sleep(1)

    def cleanup(self):
        # avoid conflict between preseed and cleanup operations
        super().execute("systemctl kill incus-preseed.service")

        instances = json.loads(
            super().succeed("incus list --format json --all-projects")
        )
        for instance in [a for a in instances if a["status"] == "Running"]:
            super().execute(
                f"incus stop --force {instance['name']} --project {instance['project']}"
            )
            super().execute(
                f"incus delete --force {instance['name']} --project {instance['project']}"
            )

    def check_instance_sysctl(self, name: str, project: str = "default"):
        self.instance_succeed(name, "systemctl status systemd-sysctl", project)
        sysctl = (
            self.instance_succeed(name, "sysctl net.ipv4.ip_forward", project)
            .strip()
            .split(" ")[-1]
        )
        assert "1" == sysctl, (
            f"systemd-sysctl configuration not correctly applied, {sysctl} != 1"
        )
