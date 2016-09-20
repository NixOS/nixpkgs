{ fetchurl }:

rec {
  major = "5";
  minor = "1";
  patch = "5";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1qg0dj0zwh5ifhmvv4k771nmyqddz4ifn75s9mr1p0nyix8zks8x";
  };
}
