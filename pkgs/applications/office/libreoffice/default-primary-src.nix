{ fetchurl }:

rec {
  major = "6";
  minor = "3";
  patch = "2";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0j9mnf1kg593icdvfh4qb42f7i772a41qks7a61z6cnazlb7r26m";
  };
}
