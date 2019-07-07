{ fetchurl }:

rec {
  major = "6";
  minor = "1";
  patch = "5";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1wh8qhqkmb89nmfcb0w6iwpdzxwqr7c5kzxgpk4gy60xin6gwjgb";
  };
}
