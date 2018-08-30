{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "5";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "16h60j7h9z48vfhhj22m64myksnrrgrnh0qc6i4bxgshmm8kkzdn";
  };
}
