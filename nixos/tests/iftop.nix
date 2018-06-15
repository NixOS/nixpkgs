import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "iftop";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ ma27 ];

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
    subtest "machine with iftop enabled", sub {
      $withIftop->waitForUnit("default.target");
      # limit to eth1 (eth0 is the test driver's control interface)
      # and don't try name lookups
      $withIftop->succeed("su -l alice -c 'iftop -t -s 1 -n -i eth1'");
    };
    subtest "machine without iftop", sub {
      $withoutIftop->waitForUnit("default.target");
      # check that iftop is there but user alice lacks capabilities
      $withoutIftop->succeed("iftop -t -s 1 -n -i eth1");
      $withoutIftop->fail("su -l alice -c 'iftop -t -s 1 -n -i eth1'");
    };
  '';
})
