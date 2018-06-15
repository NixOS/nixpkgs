{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "3";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "16w5f8jbicby9jgsrpaj7g9c0wzymcmk1qk1fqdxaykrgpss5f0j";
  };
}
