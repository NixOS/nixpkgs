{ stdenv, fetchFromGitHub, qtbase, qtsvg, qtx11extras, makeQtWrapper, muparser, cmake }:

stdenv.mkDerivation rec {
  name    = "albert-${version}";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner  = "manuelschneid3r";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "131ij525rgh2j9m2vydh79wm4bs0p3x27crar9f16rqhz15gkcpl";
  };

  nativeBuildInputs = [ cmake makeQtWrapper ];

  buildInputs = [ qtbase qtsvg qtx11extras muparser ];

  enableParallelBuilding = true;

  fixupPhase = ''
    wrapQtProgram $out/bin/albert
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/manuelSchneid3r/albert;
    description = "Desktop agnostic launcher";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };
}
