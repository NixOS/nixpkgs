let
  name = "pam";
in
import ../make-test-python.nix ({ pkgs, ... }: {
  name = "pam-fingerprint-order";

  nodes.machine = { ... }: {
    imports = [ ../../modules/profiles/minimal.nix ];

    security = {
      pam.services = {
        login = {
          fprintAuth = true;
          fprintAuthAfterPassword = true;
          allowNullPassword = true;
        };
      };
    };

    users = {
      mutableUsers = false;
      users = {
        user = {
          isNormalUser = true;
        };
      };
    };
  };

  testScript = builtins.readFile ./test_fingerprint.py;
})
