{ git, stdenv, ... }@args:
git.override (
  {
    svnSupport = stdenv.buildPlatform == stdenv.hostPlatform;
    guiSupport = true;
    sendEmailSupport = stdenv.buildPlatform == stdenv.hostPlatform;
    withSsh = true;
    withLibsecret = !stdenv.hostPlatform.isDarwin;
  }
  // removeAttrs args [ "git" ]
)
