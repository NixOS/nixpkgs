{ lib
, stdenv
, fetchurl
, pkg-config
, buildsystem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnsbmp";
  version = "0.1.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnsbmp-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-ecSTZfhg7UUb/EEJ7d7I3j6bfOWjvgaVlr0qoZJ5Mk8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "BMP Decoder for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
