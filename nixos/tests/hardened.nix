import ./make-test.nix ({ pkgs, ...} : {
  name = "hardened";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ joachifm ];
  };

  machine =
    { config, lib, pkgs, ... }:
    with lib;
    { users.users.alice = { isNormalUser = true; extraGroups = [ "proc" ]; };
      users.users.sybil = { isNormalUser = true; group = "wheel"; };
      imports = [ ../modules/profiles/hardened.nix ];
    };

  testScript =
    ''
      # Test hidepid
      subtest "hidepid", sub {
          $machine->succeed("grep -Fq hidepid=2 /proc/mounts");
          $machine->succeed("[ `su - sybil -c 'pgrep -c -u root'` = 0 ]");
          $machine->succeed("[ `su - alice -c 'pgrep -c -u root'` != 0 ]");
      };

      # Test kernel module hardening
      subtest "lock-modules", sub {
          $machine->waitForUnit("multi-user.target");
          # note: this better a be module we normally wouldn't load ...
          $machine->fail("modprobe dccp");
      };

      # Test userns
      subtest "userns", sub {
          $machine->fail("unshare --user");
      };
    '';
})
