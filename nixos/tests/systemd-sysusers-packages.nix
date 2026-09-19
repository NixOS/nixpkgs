{
  lib,
  pkgs,
  ...
}:

{
  name = "systemd-sysusers-packages";
  meta.maintainers = with lib.maintainers; [ haansn08 ];

  nodes.machine = {
    systemd.sysusers.enable = true;
    systemd.sysusers.packages = [

      (pkgs.writeTextDir "/lib/sysusers.d/test1.conf" ''
        u! test1 - "test1 system user"
        g test1group - -
      '')

      (pkgs.writeTextDir "/lib/sysusers.d/test2.conf" ''
        u! test2 - "test2 system user"
      '')

    ];
  };

  testScript = ''
    machine.wait_for_unit("systemd-sysusers.service")

    with subtest("specified users and groups do exist"):
      assert machine.succeed("userdbctl user test1")
      assert machine.succeed("userdbctl user test2")
      assert machine.succeed("userdbctl group test1group")
  '';
}
