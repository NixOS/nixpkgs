let
  name = "pam";
in
{ pkgs, ... }:
{
  name = "pam-file-contents";

  nodes.machine =
    { ... }:
    {
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

  testScript =
    builtins.replaceStrings
      [ "@@pam@@" "@@pam_ccreds@@" "@@pam_krb5@@" ]
      [ pkgs.pam.outPath pkgs.pam_ccreds.outPath pkgs.pam_krb5.outPath ]
      (builtins.readFile ./test_chfn.py);
}
