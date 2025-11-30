{
  lib,
  stdenv,
  fetchurl,
  zlibSupport ? true,
  zlib,
  sslSupport ? true,
  openssl,
  idnSupport ? true,
  libidn,
}:

stdenv.mkDerivation rec {
  pname = "gloox";
  version = "1.0.28";

  src = fetchurl {
    url = "https://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "sha256-WRvRLCSe3gtQoe9rmawN6O+cG6T9Lhhvl6dAIVzFlmw=";
  };

  # needed since gcc12
  postPatch = ''
    sed '1i#include <ctime>' -i \
      src/tests/{tag/tag_perf.cpp,zlib/zlib_perf.cpp} \
      src/examples/*.cpp
  '';

  buildInputs =
    [ ]
    ++ lib.optional zlibSupport zlib
    ++ lib.optional sslSupport openssl
    ++ lib.optional idnSupport libidn;

  meta = with lib; {
    description = "Portable high-level Jabber/XMPP library for C++";
    mainProgram = "gloox-config";
    homepage = "http://camaya.net/gloox";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.unix;
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
}
