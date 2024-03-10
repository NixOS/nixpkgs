{ lib
, stdenv
, fetchurl
, pkg-config
, buildPackages
, buildsystem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnsgif";
  version = "1.0.0";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnsgif-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-YBTIQvYUVNL1oPgkPXqNe96bfaPM/cotNGx8CyxMBhs=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "BUILD_CC=$(CC_FOR_BUILD)"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libnsgif/";
    description = "GIF Decoder for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
