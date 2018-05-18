{ fetchurl }:

rec {
  major = "5";
  minor = "4";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0icd8h221gp2dsbn6d35flwhqhcfpx66cjc5dg8yifhhvrfam74i";
  };
}
