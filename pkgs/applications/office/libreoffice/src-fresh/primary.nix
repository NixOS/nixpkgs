{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "6";
  minor = "4";
  patch = "3";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1cmbrhha7mlflnlbpla8fix07cxcgkdb7krnrgs1bylf31y5855w";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "06z9hz4m3kdcljjc6y5s18001axjibj9xiyakdndkl9pmnnhn9h3";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "0mpgrwg8z1q38j03l6m1sdpcplyjd5nz1nqaa13vfkryj2lflw45";
  };
}
