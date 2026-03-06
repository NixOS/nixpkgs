{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  udev,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libatasmart";
  version = "0.19";

  src = fetchurl {
    url = "http://0pointer.de/public/libatasmart-${finalAttrs.version}.tar.xz";
    sha256 = "138gvgdwk6h4ljrjsr09pxk1nrki4b155hqdzyr8mlk3bwsfmw31";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  outputs = [
    "out"
    "dev"
    "bin"
    "doc"
  ];

  meta = {
    homepage = "http://0pointer.de/blog/projects/being-smart.html";
    description = "Library for querying ATA SMART status";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
})
