{ fetchurl }:

rec {
  major = "6";
  minor = "2";
  patch = "4";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1drq59lc6p4s8mil2syz93l97phsbk9dcrd5gikqi2dwlzkli0gz";
  };
}
