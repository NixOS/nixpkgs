{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loki";
  version = "0.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/loki-lib/Loki/Loki%20${finalAttrs.version}/loki-${finalAttrs.version}.tar.gz";
    sha256 = "1xhwna961fl4298ac5cc629x5030zlw31vx4h8zws290amw5860g";
  };

  buildPhase = ''
    substituteInPlace Makefile.common --replace /usr $out
    make build-shared
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-std=c++11"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "C++ library of designs, containing flexible implementations of common design patterns and idioms";
    homepage = "https://loki-lib.sourceforge.net";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
})
