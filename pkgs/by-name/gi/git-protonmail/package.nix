{
  lib,
  callPackage,
}:

callPackage ../git-credential-email/package.nix {
  pname = "git-protonmail";
  scripts = [ "git-protonmail" ];
  description = "Git helper to use ProtonMail API to send emails";
  license = lib.licenses.gpl3Only;
}
