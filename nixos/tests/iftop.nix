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
    };
  };

  testScript = ''
    subtest "machine with iftop enabled", sub {
      $withIftop->start;
      $withIftop->succeed("su -l alice -c 'iftop -t -s 1'");
    };
    subtest "machine without iftop", sub {
      $withoutIftop->start;
      $withoutIftop->mustFail("su -l alice -c 'iftop -t -s 1'");
    };
  '';
})
