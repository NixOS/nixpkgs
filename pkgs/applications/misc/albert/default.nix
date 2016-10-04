{ stdenv, fetchFromGitHub, qtbase, qtsvg, qtx11extras, makeQtWrapper, muparser, cmake }:

stdenv.mkDerivation rec {
  name    = "albert-${version}";
  version = "0.8.11";

  src = fetchFromGitHub {
    owner  = "manuelschneid3r";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "12ag30l3dd05hg0d08ax4c8dvp24lgd677szkq445xzvvhggxr37";
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
