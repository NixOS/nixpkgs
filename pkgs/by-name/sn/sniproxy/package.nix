{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoreconfHook,
  gettext,
  libev,
  pcre2,
  pkg-config,
  udns,
}:

stdenv.mkDerivation rec {
  pname = "sniproxy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dlundquist";
    repo = "sniproxy";
    rev = version;
    sha256 = "sha256-htM9CrzaGnn1dnsWQ+0V6N65Og7rsFob3BlSc4UGfFU=";
  };

  patches = [
    ./gettext-0.25.patch
    (fetchurl {
      name = "compat-pcre2.patch";
      # Using Arch Linux patch because the following upstream patches do not apply cleanly:
      # https://github.com/dlundquist/sniproxy/commit/62e621f050f79eb78598b1296a089ef88a19ea91
      # https://github.com/dlundquist/sniproxy/commit/7fdd86c054a21f7ac62343010de20f28645b14d2
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/sniproxy/-/raw/3272f9f0d406c51122f90708bfcc7b4ba0eb38c9/sniproxy-0.6.1-pcre2.patch?inline=false";
      hash = "sha256-v6qdBAWXit0Zg43OsgzCTb4cSPm7gsEXVd7W8LvBgMk=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    gettext
    libev
    pcre2
    udns
  ];

  meta = with lib; {
    homepage = "https://github.com/dlundquist/sniproxy";
    description = "Transparent TLS and HTTP layer 4 proxy with SNI support";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      womfoo
      raitobezarius
    ];
    platforms = platforms.linux;
    mainProgram = "sniproxy";
  };

}
