{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "6";
  minor = "3";
  patch = "0";
  tweak = "4";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1mxflzrcm04djkj8ifyy4rwgl8bxirrvzrn864w6rgvzn43h30w7";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "0730fw2kr00b2d56jkdzjdz49c4k4mxiz879c7ikw59c5zvrh009";
  };

  # TODO: dictionaries

  help = fetchSrc {
    name = "help";
    sha256 = "1w9bqwzz75vvxxy9dgln0v6p6isf8mkqnkg1nzlaykvdgsn5sp4z";
  };
}
