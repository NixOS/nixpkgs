{ stdenv, fetchFromGitHub, qtbase, qtx11extras, makeQtWrapper, muparser, cmake }:

stdenv.mkDerivation rec {
  name    = "albert-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner  = "manuelschneid3r";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "0lzj1gbcc5sp2x1c0d3s21y55kcnnn4dmy8d205mrgnyavjrak7n";
  };

  buildInputs = [ cmake qtbase qtx11extras muparser makeQtWrapper ];

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
