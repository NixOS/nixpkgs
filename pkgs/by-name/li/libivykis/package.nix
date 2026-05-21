{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  file,
  protobufc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libivykis";

  version = "0.43.2";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${finalAttrs.version}/ivykis-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-k+PpsjdpVDfNY9SqSKjZ39izm8KKGSpXcNETxP6Qme8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    file
    protobufc
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = {
    homepage = "https://libivykis.sourceforge.net/";
    description = ''
      A thin wrapper over various OS'es implementation of I/O readiness
      notification facilities
    '';
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
