{ fetchurl }:

rec {
  major = "6";
  minor = "2";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1nzvdb6yq8bpybz7lrppr237cws6dajk3r9hc9qd0zi55kcddjpq";
  };
}
