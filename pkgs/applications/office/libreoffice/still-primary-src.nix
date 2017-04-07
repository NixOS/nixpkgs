{ fetchurl }:

rec {
  major = "5";
  minor = "2";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0w1myl4l1qhdkwqb3b52xld1sq45xyg8b45q40l6a50iccwy6j9x";
  };
}
