{
  lib,
  callPackage,
}:

let
  script = "git-credential-gmail";
in
callPackage ../package.nix {
  pname = script;
  scripts = [ script ];
  description = "Git credential helper for Gmail accounts";
  license = lib.licenses.asl20;
}
