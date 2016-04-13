{ stdenv, fetchFromGitHub, qtbase, qtsvg, qtx11extras, makeQtWrapper, muparser, cmake }:

stdenv.mkDerivation rec {
  name    = "albert-${version}";
  version = "0.8.7.2";

  src = fetchFromGitHub {
    owner  = "manuelschneid3r";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "04k6cawil6kqkmsilq5mpjy8lwgk0g08s0v23d5a83calpq3ljpc";
  };

  buildInputs = [ cmake qtbase qtsvg qtx11extras muparser makeQtWrapper ];

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
