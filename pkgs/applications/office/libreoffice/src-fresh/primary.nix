{ fetchurl }:

rec {
  fetchSrc = {name, hash}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    sha256 = hash;
  };

  major = "7";
  minor = "5";
  patch = "2";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    hash = "sha256-m1aeazMUBffTCuWnrYwDpuiiojW7FVnQPTQ1XBVdR0w=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    hash = "sha256-5/+iI/RKlYSCb+Xlz13yOeQEivmYm+RlScUWK6x5Cjw=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    hash = "sha256-Bqid2zn+lp1ROvn8v5W9tHWA2s3s4Lb1nWSmqufLusc=";
  };
}
