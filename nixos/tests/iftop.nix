{ pkgs, lib, ... }:

{
  name = "iftop";
  meta.maintainers = with lib.maintainers; [ ma27 ];

  nodes = {
    withIftop = {
      imports = [ ./common/user-account.nix ];
      programs.iftop.enable = true;
    };
    withoutIftop = {
      imports = [ ./common/user-account.nix ];
      environment.systemPackages = [ pkgs.iftop ];
    };
  };

  testScript = ''
    with subtest("machine with iftop enabled"):
        withIftop.wait_for_unit("default.target")
        # limit to eth1 (eth0 is the test driver's control interface)
        # and don't try name lookups
        withIftop.succeed("su -l alice -c 'iftop -t -s 1 -n -i eth1'")

    with subtest("machine without iftop"):
        withoutIftop.wait_for_unit("default.target")
        # check that iftop is there but user alice lacks capabilitie
        withoutIftop.succeed("iftop -t -s 1 -n -i eth1")
        withoutIftop.fail("su -l alice -c 'iftop -t -s 1 -n -i eth1'")
  '';
}
