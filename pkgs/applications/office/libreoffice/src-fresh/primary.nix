{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "7";
  minor = "0";
  patch = "3";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0b998k2dxbbj7hn3srn07fgsah236h14ncyyahamdff6h3hvqrk5";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "0s3ic79q0c16hbd6r06mwkyqhw4fdfy9z3xbqvdxp7jl64cjlaj4";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "14wjkcdmcflfcc7264jx64s6clk5rdsprx7nkbv08z0bp6ff677b";
  };
}
