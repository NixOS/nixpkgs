{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "siege";
  version = "4.1.7";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${pname}-${version}.tar.gz";
    hash = "sha256-7BQM7dFZl5OD1g2+h6AVHCwSraeHkQlaj6hK5jW5MCY=";
  };

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux [
    "-lgcc_s"
  ];

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

  # Borrowed solution from homebrew: https://github.com/Homebrew/homebrew-core/blob/1c7c95183c0984a84b1680422afab6578c300a27/Formula/s/siege.rb#L31
  CFLAGS = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";

  meta = {
    description = "HTTP load tester";
    homepage = "https://www.joedog.org/siege-home/";
    changelog = "https://github.com/JoeDog/siege/blob/v${version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
}
