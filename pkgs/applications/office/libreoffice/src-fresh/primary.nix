{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "0";
  patch = "4";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1g9akxvm7fh6lnprnc3g184qdy8gbinhb4rb60gjpw82ip6d5acz";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "1v3kpk56fm783d5wihx41jqidpclizkfxrg4n0pq95d79hdiljsl";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1np9f799ww12kggl5az6piv5fi9rf737il5a5r47r4wl2li56qqb";
  };
}
