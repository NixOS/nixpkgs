{ stdenv
, mkDerivation
, fetchurl
, libxml2
, libisds
, qmake
, qtbase
, qtsvg
, pkg-config
}:

mkDerivation rec {
  pname = "datovka";
  version = "4.15.1";

  src = fetchurl {
    url = "https://secure.nic.cz/files/datove_schranky/${version}/${pname}-${version}.tar.xz";
    sha256 = "0ab1s1r6zrqxcfjnij5ar352kzyrl1m92c04nqk6hahpzzma2p3r";
  };

  buildInputs = [ libisds qmake qtbase qtsvg libxml2 ];

  nativeBuildInputs = [ pkg-config ];

  meta = with stdenv.lib; {
    description = "Client application for operating Czech government-provided Databox infomation system";
    homepage = "https://www.datovka.cz/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
