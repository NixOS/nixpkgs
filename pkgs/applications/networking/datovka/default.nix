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
  version = "4.15.0";

  src = fetchurl {
    url = "https://secure.nic.cz/files/datove_schranky/${version}/${pname}-${version}.tar.xz";
    sha256 = "1f311qnyiay34iqpik4x492py46my89j4nnbdf6qcidnydzas8r1";
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
