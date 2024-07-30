# the ntfy-sh module was switching to DynamicUser=true. this test assures that
# the migration does not break existing setups.
#
# this test works doing a migration and asserting ntfy-sh runs properly. first,
# ntfy-sh is configured to use a static user and group. then ntfy-sh is
# started and tested. after that, ntfy-sh is shut down and a systemd drop
# in configuration file is used to upate the service configuration to use
# DynamicUser=true. then the ntfy-sh is started again and tested.

import ./make-test-python.nix {
  name = "ntfy-sh";

  nodes.machine = {
    lib,
    pkgs,
    ...
  }: {
    environment.etc."ntfy-sh-dynamic-user.conf".text = ''
      [Service]
      Group=new-ntfy-sh
      User=new-ntfy-sh
      DynamicUser=true
    '';

    services.ntfy-sh.enable = true;
    services.ntfy-sh.settings.base-url = "http://localhost:2586";

    systemd.services.ntfy-sh.serviceConfig = {
      DynamicUser = lib.mkForce false;
      ExecStartPre = [
        "${pkgs.coreutils}/bin/id"
        "${pkgs.coreutils}/bin/ls -lahd /var/lib/ntfy-sh/"
        "${pkgs.coreutils}/bin/ls -lah /var/lib/ntfy-sh/"
      ];
      Group = lib.mkForce "old-ntfy-sh";
      User = lib.mkForce "old-ntfy-sh";
    };

    users.users.old-ntfy-sh = {
      isSystemUser = true;
      group = "old-ntfy-sh";
    };

    users.groups.old-ntfy-sh = {};
  };

  testScript = ''
    import json

    msg = "Test notification"

    def test_ntfysh():
      machine.wait_for_unit("ntfy-sh.service")
      machine.wait_for_open_port(2586)

      machine.succeed(f"curl -d '{msg}' localhost:2586/test")

      text = machine.succeed("curl -s localhost:2586/test/json?poll=1")
      for line in text.splitlines():
        notif = json.loads(line)
        assert msg == notif["message"], "Wrong message"

      machine.succeed("ntfy user list")

    machine.wait_for_unit("multi-user.target")

    test_ntfysh()

    machine.succeed("systemctl stop ntfy-sh.service")
    machine.succeed("mkdir -p /run/systemd/system/ntfy-sh.service.d")
    machine.succeed("cp /etc/ntfy-sh-dynamic-user.conf /run/systemd/system/ntfy-sh.service.d/dynamic-user.conf")
    machine.succeed("systemctl daemon-reload")
    machine.succeed("systemctl start ntfy-sh.service")

    test_ntfysh()
  '';
}
