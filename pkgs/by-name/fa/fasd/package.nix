{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fasd";
  version = "2.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "whjvenyl";
    repo = "fasd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XLlS+EsjTCI5oTdHuIwiNEXiEgaO6lLgA25bm55sve0=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/whjvenyl/fasd";
    description = "Quick command-line access to files and directories for POSIX shells";
    license = lib.licenses.mit;

    longDescription = ''
      Fasd is a command-line productivity booster.
      Fasd offers quick access to files and directories for POSIX shells. It is
      inspired by tools like autojump, z and v. Fasd keeps track of files and
      directories you have accessed, so that you can quickly reference them in the
      command line.
    '';

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bcc32 ];
    mainProgram = "fasd";
  };
})
