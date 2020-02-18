{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "6";
  minor = "3";
  patch = "5";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0jnayv1i0iq1gpf3q3z9nfq6jid77d0c76675lkqb3gi07f63nzz";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "01g09bbn1ixrsfj4l0x6x8p06dz9hnlrhnr3f3xb42drmi9ipvjv";
  };

  # TODO: dictionaries

  help = fetchSrc {
    name = "help";
    sha256 = "1p38wlclv6cbjpkkq7n2mjpxy84pxi4vxc9s5kjp4dm63zzxafd6";
  };
}
