{ stdenv, fetchurl, libxml2, libisds, qmake, qtbase, qtsvg}:

stdenv.mkDerivation rec {
  name = "datovka-${version}";
  version = "4.12.0";

  src = fetchurl {
    url = "https://secure.nic.cz/files/datove_schranky/${version}/${name}.tar.xz";
    sha256 = "1dcs6yk7dflk1dxxbn5hjgc008bpgiqfcgy0cj0fxnpdn0i7za57";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ libxml2 ];
  buildInputs = [ libisds qmake qtbase qtsvg ];

  meta = with stdenv.lib; {
    description = "Client application for operating Czech government-provided Databox infomation system";
    homepage = "https://www.datovka.cz";
    license = licenses.lgpl3;
    maintainers = [ maintainers.cptMikky ];
    platforms = platforms.all;
  };
}
