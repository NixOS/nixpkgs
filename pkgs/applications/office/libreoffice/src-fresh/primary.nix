{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "0";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1rpk90g1g8m70nrj4lwkg50aiild73d29yjlgyrgg8wx6hzq7l4y";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "0m6cxyrxig8akv9183xdn6ialmjddicn676149nm506yc5y0szmi";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1kvsi28n8x3gxpiszxh84x05aw23i3z4id63pgw2s7mfclby52k9";
  };
}
