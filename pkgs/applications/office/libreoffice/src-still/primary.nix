{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "6";
  minor = "2";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1nzvdb6yq8bpybz7lrppr237cws6dajk3r9hc9qd0zi55kcddjpq";
  };

  translations = fetchSrc {
    name = "translations";
    sha256 = "1l5v9bb7n9s6i24q4mdyqyp5v4f8iy0a9dmpgw649vngj1zxdxfh";
  };

  # TODO: dictionaries

  help = fetchSrc {
    name = "help";
    sha256 = "0h4jvdbvxvgy7w2bzf4k4knqbshlr4v2ic2jsaygy52530z9xifz";
  };
}
