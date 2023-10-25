# Some tests to ensure sudo is working properly.
{ pkgs, ... }:
let
  inherit (pkgs.lib) mkIf optionalString;
  password = "helloworld";
in
  import ./make-test-python.nix ({ lib, pkgs, ...} : {
    name = "sudo-rs";
    meta.maintainers = pkgs.sudo-rs.meta.maintainers;

    nodes.machine =
      { lib, ... }:
      {
        environment.systemPackages = [ pkgs.faketty ];
        users.groups = { foobar = {}; barfoo = {}; baz = { gid = 1337; }; };
        users.users = {
          test0 = { isNormalUser = true; extraGroups = [ "wheel" ]; };
          test1 = { isNormalUser = true; password = password; };
          test2 = { isNormalUser = true; extraGroups = [ "foobar" ]; password = password; };
          test3 = { isNormalUser = true; extraGroups = [ "barfoo" ]; };
          test4 = { isNormalUser = true; extraGroups = [ "baz" ]; };
          test5 = { isNormalUser = true; };
        };

        security.sudo.enable = false;

        security.sudo-rs = {
          enable = true;
          package = pkgs.sudo-rs;
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
            { groups = [ "barfoo" 1337 ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
            { users = [ "test5" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; runAs = "test1:barfoo"; }
          ];
        };
      };

    nodes.strict = { ... }: {
      environment.systemPackages = [ pkgs.faketty ];
      users.users = {
        admin = { isNormalUser = true; extraGroups = [ "wheel" ]; };
        noadmin = { isNormalUser = true; };
      };

      security.sudo.enable = false;

      security.sudo-rs = {
        package = pkgs.sudo-rs;
        enable = true;
        wheelNeedsPassword = false;
        execWheelOnly = true;
      };
    };

    testScript =
      ''
        with subtest("users in wheel group should have passwordless sudo"):
            machine.succeed('faketty -- su - test0 -c "sudo -u root true"')

        with subtest("test1 user should have sudo with password"):
            machine.succeed('faketty -- su - test1 -c "echo ${password} | sudo -S -u root true"')

        with subtest("test1 user should not be able to use sudo without password"):
            machine.fail('faketty -- su - test1 -c "sudo -n -u root true"')

        with subtest("users in group 'foobar' should be able to use sudo with password"):
            machine.succeed('faketty -- su - test2 -c "echo ${password} | sudo -S -u root true"')

        with subtest("users in group 'barfoo' should be able to use sudo without password"):
            machine.succeed("sudo -u test3 sudo -n -u root true")

        with subtest("users in group 'baz' (GID 1337)"):
            machine.succeed("sudo -u test4 sudo -n -u root echo true")

        with subtest("test5 user should be able to run commands under test1"):
            machine.succeed("sudo -u test5 sudo -n -u test1 true")

        with subtest("test5 user should not be able to run commands under root"):
            machine.fail("sudo -u test5 sudo -n -u root true 2>/dev/null")

        with subtest("users in wheel should be able to run sudo despite execWheelOnly"):
            strict.succeed('faketty -- su - admin -c "sudo -u root true"')

        with subtest("non-wheel users should be unable to run sudo thanks to execWheelOnly"):
            strict.fail('faketty -- su - noadmin -c "sudo --help"')
      '';
  })
