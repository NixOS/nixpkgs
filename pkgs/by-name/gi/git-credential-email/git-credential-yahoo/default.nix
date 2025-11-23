{
  lib,
  callPackage,
}:

let
  script = "git-credential-yahoo";
in
callPackage ../package.nix {
  pname = script;
  scripts = [ script ];
  description = "Git credential helper for Yahoo accounts";
  license = lib.licenses.asl20;
}
