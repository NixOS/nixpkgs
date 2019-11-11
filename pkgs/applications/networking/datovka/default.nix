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
  version = "4.14.0";

  src = fetchurl {
    url = "https://secure.nic.cz/files/datove_schranky/${version}/${pname}-${version}.tar.xz";
    sha256 = "0q7zlq522wdgwxgd3jxmxvr3awclcy0mbw3qaymwzn2b8d35168r";
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
