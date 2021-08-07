{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "4";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1jsskhnlyra7q6d12kkc8dxq5fgrnd8grl32bdck7j9hkwv6d13m";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "0cslzhp5ic1w7hnl6wbyxrxhczdmap1g1hh1nj9sgpw9iqdryqj7";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "091yhm1qkxgvv130a1yzmmikchvxvp8109mcdrlpybp4gc276l8q";
  };
}
