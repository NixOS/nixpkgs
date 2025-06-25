{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcap-ng";
  version = "0.8.5";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/libcap-ng/libcap-ng-${finalAttrs.version}.tar.gz";
    hash = "sha256-O6UpTRy9+pivqs+8ALavntK4PoohgXGF39hEzIx6xv8=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  configureFlags = [
    "--without-python"
  ];

  meta = {
    changelog = "https://people.redhat.com/sgrubb/libcap-ng/ChangeLog";
    description = "Library for working with POSIX capabilities";
    homepage = "https://people.redhat.com/sgrubb/libcap-ng/";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
  };
})
