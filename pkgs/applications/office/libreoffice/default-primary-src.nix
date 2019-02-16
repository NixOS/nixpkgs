{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "7";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0wjcnra06d9z51kjb5njlpy4d8zd8wqfvkif2kc6mzhrsz5kqqxr";
  };
}
