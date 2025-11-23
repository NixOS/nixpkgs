{
  lib,
  callPackage,
}:

let
  script = "git-credential-outlook";
in
callPackage ../package.nix {
  pname = script;
  scripts = [ script ];
  description = "Git credential helper for Microsoft Outlook accounts";
  license = lib.licenses.asl20;
}
