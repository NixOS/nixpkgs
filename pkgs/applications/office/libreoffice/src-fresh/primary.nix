{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "2";
  patch = "4";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "sha256-Ymi5BmpgWGzwpfXtmWDN+Gpf9Yb+Zpm/TSltWA3gjyE=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "sha256-8nzCt7/J7gqJPtHOrVu7UTonJw1pxu4fnLWJyWOUHa8=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "sha256-rZb1ej3GbgXOHOZWVKKJVuir2urLmvGmrdpB1vpcaCk=";
  };
}
