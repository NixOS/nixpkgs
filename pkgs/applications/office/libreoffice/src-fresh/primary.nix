{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "0";
  patch = "0";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "sha256-sl+vgnLGIWtyw8Y/ovVsxThdOMg2Gby4SRaiaqvZVB0=";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "sha256-i3yfD5cmM6D9BctjablIFRqfibjrwLAaxxPIsQdk0sY=";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "sha256-hYBEEPRmh16zgGZBUN20xfTY6qL07aKMC1lC/0ij9/0=";
  };
}
