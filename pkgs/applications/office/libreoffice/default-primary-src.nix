{ fetchurl }:

rec {
  major = "6";
  minor = "3";
  patch = "0";
  tweak = "4";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1mxflzrcm04djkj8ifyy4rwgl8bxirrvzrn864w6rgvzn43h30w7";
  };
}
