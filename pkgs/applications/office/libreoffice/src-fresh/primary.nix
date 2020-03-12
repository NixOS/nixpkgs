{ fetchurl }:

rec {
  fetchSrc = {name, sha256}: fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  major = "6";
  minor = "4";
  patch = "1";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "03fqpkilz4yi35l447hb9r8gjwj23l61bpdkwg21jm8blm8kkvyj";
  };

  # FIXME rename
  translations = fetchSrc {
    name = "translations";
    sha256 = "0a7arjlxxy7hjm1brxwd124bf1gkbl92bgygi3sbbhbsv07pjdcr";
  };

  # the "dictionaries" archive is not used for LO build because we already build hunspellDicts packages from
  # it and LibreOffice can use these by pointing DICPATH environment variable at the hunspell directory

  help = fetchSrc {
    name = "help";
    sha256 = "1hfllrdyxrg5mgqry3dcrhjbdrd0d27k5mvv4sfj7nwjlmjh8rqq";
  };
}
