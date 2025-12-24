{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "6.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/${pname}-${version}.tar.gz";
    sha256 = "sha256-Zfd1KYiUnBGG02h0XsGi2eFZfNiyDe59PL7Q2o705Nw=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = "https://diskinfo-di.sourceforge.io/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ manveru ];
    platforms = lib.platforms.all;
  };
}
