{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "0";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0bk1dc6g8z5akrprfxxy3dm0vdmihaaxnsprxpqbqmqrqzkzg8cn";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "04f76r311hppil656ajab52x0xwqszazlgssyi5w97wak2zkmqgj";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1xmvlj9nrmg8448k4zfaxn5qqxa4amnvvhs1l1smi2bz3xh4xn2d";
  };
}
