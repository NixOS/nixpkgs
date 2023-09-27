{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit hash;
  };

  major = "7";
  minor = "6";
  patch = "2";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    hash = "sha256-5dJzO9As4kwwIHeVt3ufXitaujoUdzN1+1zCKO0rnKI=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    hash = "sha256-WyOfphJ+h7ALeZCl7e+WsfpSL4DB2W4/h0nZUZD21go=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    hash = "sha256-a9wnAnpgMDF4XWxlB4UHOt2NVYcquBoVBnRZ7hts0Ug=";
  };
}
