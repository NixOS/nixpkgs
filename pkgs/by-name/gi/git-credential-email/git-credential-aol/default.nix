{
  lib,
  callPackage,
}:

let
  script = "git-credential-aol";
in
callPackage ../package.nix {
  pname = script;
  scripts = [ script ];
  description = "Git credential helper for AOL accounts";
  license = lib.licenses.asl20;
}
