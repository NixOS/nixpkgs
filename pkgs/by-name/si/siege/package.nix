{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "siege";
  version = "4.1.7";

  src = fetchurl {
    url = "http://download.joedog.org/siege/siege-${finalAttrs.version}.tar.gz";
    hash = "sha256-7BQM7dFZl5OD1g2+h6AVHCwSraeHkQlaj6hK5jW5MCY=";
  };

  env =
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      NIX_LDFLAGS = toString [ "-lgcc_s" ];
    }
    // lib.optionalAttrs stdenv.cc.isClang {
      # Borrowed solution from homebrew: https://github.com/Homebrew/homebrew-core/blob/1c7c95183c0984a84b1680422afab6578c300a27/Formula/s/siege.rb#L31
      CFLAGS = "-Wno-int-conversion";
    };

  buildInputs = [
    openssl
    zlib
  ];

  prePatch = ''
    sed -i -e 's/u_int32_t/uint32_t/g' -e '1i#include <stdint.h>' src/hash.c
  '';

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  meta = {
    description = "HTTP load tester";
    homepage = "https://www.joedog.org/siege-home/";
    changelog = "https://github.com/JoeDog/siege/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
