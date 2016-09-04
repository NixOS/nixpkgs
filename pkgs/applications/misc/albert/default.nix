{ stdenv, fetchFromGitHub, qtbase, qtsvg, qtx11extras, makeQtWrapper, muparser, cmake }:

stdenv.mkDerivation rec {
  name    = "albert-${version}";
  version = "0.8.10";

  src = fetchFromGitHub {
    owner  = "manuelschneid3r";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "1x8fpc6rnjifh405p385avdaww4v8ld6qwczqwmkzgbcn15gman7";
  };

  nativeBuildInputs = [ cmake makeQtWrapper ];

  buildInputs = [ qtbase qtsvg qtx11extras muparser ];

  enableParallelBuilding = true;

  fixupPhase = ''
    wrapQtProgram $out/bin/albert
  '';

  meta = {
    homepage    = https://github.com/manuelSchneid3r/albert;
    description = "Desktop agnostic launcher";
    license     = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.ericsagnes ];
    platforms = stdenv.lib.platforms.linux;
  };
}
