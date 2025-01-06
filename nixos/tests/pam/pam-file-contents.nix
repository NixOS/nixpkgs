let
  name = "pam";
in
import ../make-test-python.nix ({ pkgs, ... }: {
  name = "pam-file-contents";

  nodes.machine = { ... }: {
    imports = [ ../../modules/profiles/minimal.nix ];

    security.krb5.enable = true;

    users = {
      mutableUsers = false;
      users = {
        user = {
          isNormalUser = true;
        };
      };
    };
  };

  testScript = builtins.replaceStrings
    [ "@@pam_ccreds@@" "@@pam_krb5@@" ]
    [ pkgs.pam_ccreds.outPath pkgs.pam_krb5.outPath ]
    (builtins.readFile ./test_chfn.py);
})
