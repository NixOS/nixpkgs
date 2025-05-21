{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "6.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/${pname}-${version}.tar.gz";
    sha256 = "sha256-e2Y+TbBEsfpJhr0Bj4J8GOlv5tH5o2cy3LsEUOf1GMs=";
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
