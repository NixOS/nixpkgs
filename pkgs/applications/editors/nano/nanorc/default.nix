{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "nanorc";
  version = "2020-01-25";

  src = fetchFromGitHub {
    owner = "scopatz";
    repo = "nanorc";
    rev = "2020.1.25";
    sha256 = "1y8jk3jsl4bd6r4hzmxzcf77hv8bwm0318yv7y2npkkd3a060z8d";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share

    install *.nanorc $out/share/
  '';

  meta = {
    description = "Improved Nano Syntax Highlighting Files";
    homepage = "https://github.com/scopatz/nanorc";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ nequissimus ];
    platforms = stdenv.lib.platforms.all;
  };
}
