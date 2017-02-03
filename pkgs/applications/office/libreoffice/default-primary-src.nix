{ fetchurl }:

rec {
  major = "5";
  minor = "3";
  patch = "0";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0vjmc8id9krpy9n4f0yil8k782cdzwmk53lvszi7r32b3ig23f84";
  };
}
