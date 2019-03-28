{ fetchurl }:

rec {
  major = "6";
  minor = "2";
  patch = "1";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0p2r48n27v5ifbj3cb9bs38nb6699awmdqx4shy1c6p28b24y78f";
  };
}
