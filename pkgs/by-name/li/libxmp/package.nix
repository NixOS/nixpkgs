{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libxmp";
  version = "4.6.1";

  meta = with lib; {
    description = "Extended module player library";
    homepage = "https://xmp.sourceforge.net/";
    longDescription = ''
      Libxmp is a library that renders module files to PCM data. It supports
      over 90 mainstream and obscure module formats including Protracker (MOD),
      Scream Tracker 3 (S3M), Fast Tracker II (XM), and Impulse Tracker (IT).
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };

  src = fetchurl {
    url = "mirror://sourceforge/xmp/libxmp/${pname}-${version}.tar.gz";
    sha256 = "sha256-r2Becsg7JKuvAyaTR+JOvD/AbNe0lWUqLGGcH1FLxcs=";
  };
}
