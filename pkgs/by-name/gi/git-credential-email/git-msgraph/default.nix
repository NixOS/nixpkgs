{
  lib,
  callPackage,
}:

let
  script = "git-msgraph";
in
callPackage ../package.nix {
  pname = script;
  scripts = [ script ];
  description = "Git helper to use Microsoft Graph API instead of SMTP to send emails";
  license = lib.licenses.asl20;
}
