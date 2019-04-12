{ fetchurl }:

rec {
  major = "6";
  minor = "2";
  patch = "2";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0s8zwc2bp1zs7hvyhjz0hpb8w97jm0cdb179p56z7svvmald6fmq";
  };
}
