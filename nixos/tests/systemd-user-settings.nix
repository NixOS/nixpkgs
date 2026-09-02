{
  name = "systemd-user-settings";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { lib, ... }:
    {
      systemd.user.settings.Manager = {
        DefaultTimeoutStartSec = lib.mkForce "60";
        DefaultEnvironment = "FOO=bar";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("settings.Manager renders user.conf"):
      machine.succeed("grep -F '[Manager]' /etc/systemd/user.conf")
      machine.succeed("grep -F 'DefaultTimeoutStartSec=60' /etc/systemd/user.conf")
      machine.succeed("grep -F 'DefaultEnvironment=FOO=bar' /etc/systemd/user.conf")
  '';
}
