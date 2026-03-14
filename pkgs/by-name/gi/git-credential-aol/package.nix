{
  lib,
  callPackage,
}:

callPackage ../git-credential-email/package.nix {
  pname = "git-credential-aol";
  scripts = [ "git-credential-aol" ];
  description = "Git credential helper for AOL accounts";
  license = lib.licenses.asl20;
}
