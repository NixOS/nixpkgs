{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "2";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1y19p9701msf6jjzp9d5ighvmyjzj68qzhm2bk3l5p16ys8qk9bb";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "1j5251lbc35d521d92w52lgps0v5pg8mhr8y3r6x2nl9p0gvw957";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1bsrkmzhhpyrmi7akmdfvz4zb543fc093az9965k14rp8l6rhnvf";
  };
}
