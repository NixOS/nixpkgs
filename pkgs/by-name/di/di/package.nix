{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "5.0.14";

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/${pname}-${version}.tar.gz";
    sha256 = "sha256-H/5UgMT7CfzaCQnIsytRnGC1cV2mF6/SQxEU1dVDKtk=";
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
