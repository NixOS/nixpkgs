# Some tests to ensure doas is working properly.
import ./make-test-python.nix (
  { lib, ... }: {
    name = "doas";
    meta = with lib.maintainers; {
      maintainers = [ cole-h ];
    };

    machine =
      { ... }:
        {
          users.groups = { foobar = {}; barfoo = {}; baz = { gid = 1337; }; };
          users.users = {
            test0 = { isNormalUser = true; extraGroups = [ "wheel" ]; };
            test1 = { isNormalUser = true; };
            test2 = { isNormalUser = true; extraGroups = [ "foobar" ]; };
            test3 = { isNormalUser = true; extraGroups = [ "barfoo" ]; };
            test4 = { isNormalUser = true; extraGroups = [ "baz" ]; };
            test5 = { isNormalUser = true; };
            test6 = { isNormalUser = true; };
            test7 = { isNormalUser = true; };
          };

          security.doas = {
            enable = true;
            wheelNeedsPassword = false;

            extraRules = [
              { users = [ "test1" ]; groups = [ "foobar" ]; }
              { users = [ "test2" ]; noPass = true; setEnv = [ "CORRECT" "HORSE=BATTERY" ]; }
              { groups = [ "barfoo" 1337 ]; noPass = true; }
              { users = [ "test5" ]; noPass = true; keepEnv = true; runAs = "test1"; }
              { users = [ "test6" ]; noPass = true; keepEnv = true; setEnv = [ "-STAPLE" ]; }
              { users = [ "test7" ]; noPass = true; setEnv = [ "-SSH_AUTH_SOCK" ]; }
            ];
          };
        };

    testScript = ''
      with subtest("users in wheel group should have passwordless doas"):
          machine.succeed('su - test0 -c "doas -u root true"')

      with subtest("test1 user should not be able to use doas without password"):
          machine.fail('su - test1 -c "doas -n -u root true"')

      with subtest("test2 user should be able to keep some env"):
          if "CORRECT=1" not in machine.succeed('su - test2 -c "CORRECT=1 doas env"'):
              raise Exception("failed to keep CORRECT")

          if "HORSE=BATTERY" not in machine.succeed('su - test2 -c "doas env"'):
              raise Exception("failed to setenv HORSE=BATTERY")

      with subtest("users in group 'barfoo' shouldn't require password"):
          machine.succeed("doas -u test3 doas -n -u root true")

      with subtest("users in group 'baz' (GID 1337) shouldn't require password"):
          machine.succeed("doas -u test4 doas -n -u root echo true")

      with subtest("test5 user should be able to run commands under test1"):
          machine.succeed("doas -u test5 doas -n -u test1 true")

      with subtest("test5 user should not be able to run commands under root"):
          machine.fail("doas -u test5 doas -n -u root true")

      with subtest("test6 user should be able to keepenv"):
          envs = ["BATTERY=HORSE", "CORRECT=false"]
          out = machine.succeed(
              'su - test6 -c "BATTERY=HORSE CORRECT=false STAPLE=Tr0ub4dor doas env"'
          )

          if not all(env in out for env in envs):
              raise Exception("failed to keep BATTERY or CORRECT")
          if "STAPLE=Tr0ub4dor" in out:
              raise Exception("failed to exclude STAPLE")

      with subtest("test7 should not have access to SSH_AUTH_SOCK"):
          if "SSH_AUTH_SOCK=HOLEY" in machine.succeed(
              'su - test7 -c "SSH_AUTH_SOCK=HOLEY doas env"'
          ):
              raise Exception("failed to exclude SSH_AUTH_SOCK")

      # Test that the doas setuid wrapper precedes the unwrapped version in PATH after
      # calling doas.
      # The PATH set by doas is defined in
      # ../../pkgs/tools/security/doas/0001-add-NixOS-specific-dirs-to-safe-PATH.patch
      with subtest("recursive calls to doas from subprocesses should succeed"):
          machine.succeed('doas -u test0 sh -c "doas -u test0 true"')

      with subtest("test0 should inherit TERMINFO_DIRS from the user environment"):
          dirs = machine.succeed(
               "su - test0 -c 'doas -u root $SHELL -c \"echo \$TERMINFO_DIRS\"'"
          )

          if not "test0" in dirs:
             raise Exception(f"user profile TERMINFO_DIRS is not preserved: {dirs}")
    '';
  }
)
