{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "6.2.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/${pname}-${version}.tar.gz";
    sha256 = "sha256-Ge7rfrytMGGueBTNrlWTrM+yuyYc4keVpgSigsv8YP4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = "https://diskinfo-di.sourceforge.io/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
  };
}
