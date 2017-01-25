{ fetchurl }:

rec {
  major = "5";
  minor = "1";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "150xb76pc3889gfy4jrnq8sidymm1aihkm5pzy8b1fdy51zip804";
  };
}
