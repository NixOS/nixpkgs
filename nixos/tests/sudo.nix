# Some tests to ensure sudo is working properly.

let
  password = "helloworld";

in
  import ./make-test.nix ({ pkgs, ...} : {
    name = "sudo";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ lschuermann ];
    };

    machine =
      { lib, ... }:
      with lib;
      {
        users.groups = { foobar = {}; barfoo = {}; baz = { gid = 1337; }; };
        users.users = {
          test0 = { isNormalUser = true; extraGroups = [ "wheel" ]; };
          test1 = { isNormalUser = true; password = password; };
          test2 = { isNormalUser = true; extraGroups = [ "foobar" ]; password = password; };
          test3 = { isNormalUser = true; extraGroups = [ "barfoo" ]; };
          test4 = { isNormalUser = true; extraGroups = [ "baz" ]; };
          test5 = { isNormalUser = true; };
        };

        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;

          extraRules = [
            # SUDOERS SYNTAX CHECK (Test whether the module produces a valid output;
            # errors being detected by the visudo checks.

            # These should not create any entries
            { users = [ "notest1" ]; commands = [ ]; }
            { commands = [ { command = "ALL"; options = [ ]; } ]; }

            # Test defining commands with the options syntax, though not setting any options
            { users = [ "notest2" ]; commands = [ { command = "ALL"; options = [ ]; } ]; }


            # CONFIGURATION FOR TEST CASES
            { users = [ "test1" ]; groups = [ "foobar" ]; commands = [ "ALL" ]; }
            { groups = [ "barfoo" 1337 ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" "NOSETENV" ]; } ]; }
            { users = [ "test5" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; } ]; runAs = "test1:barfoo"; }
          ];
        };
      };

    testScript =
      ''
        subtest "users in wheel group should have passwordless sudo", sub {
            $machine->succeed("su - test0 -c \"sudo -u root true\"");
        };

        subtest "test1 user should have sudo with password", sub {
            $machine->succeed("su - test1 -c \"echo ${password} | sudo -S -u root true\"");
        };

        subtest "test1 user should not be able to use sudo without password", sub {
            $machine->fail("su - test1 -c \"sudo -n -u root true\"");
        };

        subtest "users in group 'foobar' should be able to use sudo with password", sub {
            $machine->succeed("sudo -u test2 echo ${password} | sudo -S -u root true");
        };

        subtest "users in group 'barfoo' should be able to use sudo without password", sub {
            $machine->succeed("sudo -u test3 sudo -n -u root true");
        };

        subtest "users in group 'baz' (GID 1337) should be able to use sudo without password", sub {
            $machine->succeed("sudo -u test4 sudo -n -u root echo true");
        };

        subtest "test5 user should be able to run commands under test1", sub {
            $machine->succeed("sudo -u test5 sudo -n -u test1 true");
        };

        subtest "test5 user should not be able to run commands under root", sub {
            $machine->fail("sudo -u test5 sudo -n -u root true");
        };

        subtest "test5 user should be able to keep his environment", sub {
            $machine->succeed("sudo -u test5 sudo -n -E -u test1 true");
        };

        subtest "users in group 'barfoo' should not be able to keep their environment", sub {
            $machine->fail("sudo -u test3 sudo -n -E -u root true");
        };
      '';
  })
