{ fetchurl }:

rec {
  major = "5";
  minor = "4";
  patch = "1";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0c17193vcf4nj8l5k9q87byv27px74kzp0hvgr1dfz5700cv086k";
  };
}
