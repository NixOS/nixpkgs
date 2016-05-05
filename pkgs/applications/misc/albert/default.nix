{ stdenv, fetchFromGitHub, qtbase, qtsvg, qtx11extras, makeQtWrapper, muparser, cmake }:

stdenv.mkDerivation rec {
  name    = "albert-${version}";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner  = "manuelschneid3r";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "1mqxy5xbvgzykg2vvr2d1p9kr2viga1pqxslkg9y1x05kdhr2zal";
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
  };
}
