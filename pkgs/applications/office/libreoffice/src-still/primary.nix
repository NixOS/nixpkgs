{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "1";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1g1nlnmgxka1xj3800ra7j28y08k1irz7a24awx1gyjs9fci58qq";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "0kblfwcnsc0pz96wxmkghmchjd31h0w1wjxlqxqbqqpz3vbr61k3";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1b28xqgvfnx62zgnxfisi58r7nhixvz35pmq8cb20ayxhdfg6v31";
  };
}
