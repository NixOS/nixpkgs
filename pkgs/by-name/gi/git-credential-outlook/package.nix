{
  lib,
  callPackage,
}:

callPackage ../git-credential-email/package.nix {
  pname = "git-credential-outlook";
  scripts = [ "git-credential-outlook" ];
  description = "Git credential helper for Microsoft Outlook accounts";
  license = lib.licenses.asl20;
}
