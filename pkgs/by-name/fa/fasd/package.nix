{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "fasd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "whjvenyl";
    repo = "fasd";
    rev = "d58aaf42213463e49a0d704ad598026947f7404e";
    hash = "sha256-XLlS+EsjTCI5oTdHuIwiNEXiEgaO6lLgA25bm55sve0=";
  };

  installPhase = ''
    PREFIX=$out make install
  '';

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
}
