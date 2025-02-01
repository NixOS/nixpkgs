{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.54.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/${pname}-${version}.tar.gz";
    sha256 = "sha256-tAHmR+zDyKaXZRvSmtHMauMZ9poki03E068HQvZLT/s=";
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
