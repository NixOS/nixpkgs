{ fetchurl }:

rec {
  major = "5";
  minor = "3";
  patch = "1";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1zsl0z0i8pw532x2lmwd64ms6igibkkjhwf01zmm2kpnr9ycsijp";
  };
}
