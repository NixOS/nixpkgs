{
  lib,
  callPackage,
}:

callPackage ../package.nix {
  pname = "git-credential-yahoo";
  scripts = [ "git-credential-yahoo" ];
  description = "Git credential helper for Yahoo accounts";
  license = lib.licenses.asl20;
}
