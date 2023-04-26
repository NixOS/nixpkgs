# Some tests to ensure doas-sudo-shim is working properly.

import ./make-test-python.nix (
  { lib, ... }: with lib; {
    name = "doas-sudo-shim";
    meta.maintainers = with maintainers; [ dsuetin ];

    nodes.machine = {
      users.users = {
        test0 = { isNormalUser = true; extraGroups = [ "wheel" ]; };
        test1 = { isNormalUser = true; };
      };

      security.sudo.enable = false;

      security.doas = {
        enable = true;
        sudoShim.enable = true;
        wheelNeedsPassword = false;
      };
    };

    testScript = ''
      with subtest("doas-sudo-shim should work without any options"):
          machine.succeed("[ $(su test0 -c 'sudo whoami') = 'root' ]")

      with subtest("doas-sudo-shim should work with user option"):
          machine.succeed("[ $(su test0 -c 'sudo -u test1 whoami') = 'test1' ]")
    '';
  }
)
