{ fetchurl }:

rec {
  major = "5";
  minor = "2";
  patch = "2";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1q6rv935g633ngg10hzi23sg0wqfq2apyffagk7mj1kan2hflljr";
  };
}
