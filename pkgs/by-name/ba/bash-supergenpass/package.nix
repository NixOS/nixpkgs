{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  makeWrapper,
  openssl,
  coreutils,
  gnugrep,
}:

stdenv.mkDerivation {
  pname = "bash-supergenpass";
  version = "0-unstable-2026-04-09";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "lanzz";
    repo = "bash-supergenpass";
    rev = "0d1e6d7f1f0ea8d1f5bd609013651ea2c32386f0";
    sha256 = "T9cPMeGIbCfqkGylNObeg2RFBS0zFmmJNED5VRaUCoo=";
  };

  installPhase = ''
    install -m755 -D supergenpass.sh "$out/bin/supergenpass"
    wrapProgram "$out/bin/supergenpass" --prefix PATH : "${
      lib.makeBinPath [
        openssl
        coreutils
        gnugrep
      ]
    }"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/lanzz/bash-supergenpass.git";
  };

  meta = {
    description = "Bash shell-script implementation of SuperGenPass password generation";
    longDescription = ''
      Bash shell-script implementation of SuperGenPass password generation
      Usage: ./supergenpass.sh <domain> [ <length> ]

      Default <length> is 10, which is also the original SuperGenPass default length.

      The <domain> parameter is also optional, but it does not make much sense to omit it.

      supergenpass will ask for your master password interactively, and it will not be displayed on your terminal.
    '';
    homepage = "https://github.com/lanzz/bash-supergenpass";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "supergenpass";
    platforms = lib.platforms.all;
  };
}
