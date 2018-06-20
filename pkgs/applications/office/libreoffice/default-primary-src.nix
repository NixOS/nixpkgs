{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "4";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1xqh4l1nrvgara4ni9zk8pqywz3gbq4a8sw9v0ggxsch409zp0ch";
  };
}
