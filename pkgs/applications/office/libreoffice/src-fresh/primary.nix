{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "3";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1gr9c8kv7nc9kaag1sw9r36843pfba1my80afx7p0lxj0k8pzbrm";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "09xkr6jmnwq55savw9xjsy8l8zcyflnsg4nfwhknvm3ls8sqj4w6";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "0dc981vmxfdwlyfgq84axkr99d8chm1ypknj39v0cmaqn56lpwg0";
  };
}
