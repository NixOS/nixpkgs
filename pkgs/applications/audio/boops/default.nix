{ stdenv, fetchFromGitHub, xorg, cairo, lv2, libsndfile, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BOops";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "0mhb0x1rdf1bcqnralg12mdpd7ihzv8ifzp9xv5c2ybcsjx4d9ad";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2 libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BOops";
    description = "Sound glitch effect sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
