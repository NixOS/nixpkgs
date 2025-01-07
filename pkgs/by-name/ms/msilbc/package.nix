{
  lib,
  stdenv,
  fetchurl,
  ilbc,
  mediastreamer,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "msilbc";
  version = "2.1.2";

  src = fetchurl {
    url = "mirror://savannah/linphone/plugins/sources/${pname}-${version}.tar.gz";
    sha256 = "07j02y994ybh274fp7ydjvi76h34y2c34ndwjpjfcwwr03b48cfp";
  };

  propagatedBuildInputs = [
    ilbc
    mediastreamer
  ];
  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "ILBC_LIBS=ilbc"
    "ILBC_CFLAGS=-I${ilbc}/include"
    "MEDIASTREAMER_LIBS=mediastreamer"
    "MEDIASTREAMER_CFLAGS=-I${mediastreamer}/include"
  ];

  meta = {
    description = "Mediastreamer plugin for the iLBC audio codec";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
}
