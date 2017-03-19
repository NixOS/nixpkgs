{ stdenv, fetchFromGitHub, libX11}:

stdenv.mkDerivation rec {
  name = "xrq-unstable-2016-01-15";

  src = fetchFromGitHub {
	  owner = "arianon";
	  repo = "xrq";
    rev = "d5dc19c63881ebdd1287a02968e3a1447dde14a9";
    sha256 = "1bxf6h3fjw3kjraz7028m7p229l423y1ngy88lqvf0xl1g3dhp36";
  };

  installPhase = ''
    make PREFIX=$out install
  '';

  outputs = [ "out" "doc" ];

  buildInputs = [ libX11 ];

  meta = {
    description = "X utility for querying xrdb";
    homepage = https://github.com/arianon/xrq;
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; unix;
  };
}
