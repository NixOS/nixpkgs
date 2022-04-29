{ lib
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
  version = "4.15.6";

  src = fetchurl {
    url = "https://secure.nic.cz/files/datove_schranky/${version}/${pname}-${version}.tar.xz";
    sha256 = "1qs1yd9qqsf56jm9w6sffkqb2l8s3i9qgi2q8vd59ss19ym6yky2";
  };

  buildInputs = [ libisds qmake qtbase qtsvg libxml2 ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Client application for operating Czech government-provided Databox infomation system";
    homepage = "https://www.datovka.cz/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
