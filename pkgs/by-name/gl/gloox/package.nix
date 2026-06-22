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

stdenv.mkDerivation (finalAttrs: {
  pname = "gloox";
  version = "1.0.28";

  src = fetchurl {
    url = "https://camaya.net/download/gloox-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-WRvRLCSe3gtQoe9rmawN6O+cG6T9Lhhvl6dAIVzFlmw=";
  };

  patches = [
    # Clang rejects `{ 0 }` as SSL_export_keying_material's context pointer argument.
    ./tls-openssl-clang.patch
  ];

  # needed since gcc12
  postPatch = ''
    substituteInPlace \
      src/tests/tag/tag_perf.cpp \
      src/tests/zlib/zlib_perf.cpp \
      --replace-fail \
        "#include <sys/time.h>" \
        $'#include <ctime>\n#include <sys/time.h>'

    substituteInPlace src/examples/*.cpp \
      --replace-fail \
        "#include <stdio.h>" \
        $'#include <ctime>\n#include <stdio.h>'
  '';

  buildInputs = lib.flatten [
    (lib.optional zlibSupport zlib)
    (lib.optional sslSupport openssl)
    (lib.optional idnSupport libidn)
  ];

  meta = {
    description = "Portable high-level Jabber/XMPP library for C++";
    mainProgram = "gloox-config";
    homepage = "http://camaya.net/gloox";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.philocalyst ];
    platforms = lib.platforms.unix;
  };
})
