{
  lib,
  callPackage,
}:

callPackage ../package.nix {
  pname = "git-credential-gmail";
  scripts = [ "git-credential-gmail" ];
  description = "Git credential helper for Gmail accounts";
  license = lib.licenses.asl20;
}
