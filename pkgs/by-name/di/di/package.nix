{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.54";

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/${pname}-${version}.tar.gz";
    sha256 = "sha256-9QD8H+J1hnOOEtdz2rya8Qj+RpDWu8giCpw8P3dPh0g=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = "https://diskinfo-di.sourceforge.io/";
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.all;
  };
}
