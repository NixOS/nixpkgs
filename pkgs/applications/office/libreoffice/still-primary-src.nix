{ fetchurl }:

rec {
  major = "5";
  minor = "4";
  patch = "5";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "167bh6jgyhfcvn3g7xghkg4nb99h91diypdlry5df21xs8bis5gb";
  };
}
