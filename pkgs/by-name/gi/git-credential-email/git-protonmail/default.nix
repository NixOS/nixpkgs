{
  lib,
  callPackage,
}:

let
  script = "git-protonmail";
in
callPackage ../package.nix {
  pname = script;
  scripts = [ script ];
  description = "Git helper to use ProtonMail API to send emails";
  license = lib.licenses.gpl3Only;
}
