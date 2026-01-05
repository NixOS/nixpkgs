{
  lib,
  stdenv,
  fetchurl,
  gettext,
  python3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iso-codes";
  version = "4.19.0";

  src = fetchurl {
    url =
      with finalAttrs;
      "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v${version}/${pname}-v${version}.tar.gz";
    hash = "sha256-SxQ6iR/rfRu2TkT+PvJT7za6EYXR0SnBQlM43G5G4n0=";
  };

  nativeBuildInputs = [
    gettext
    python3
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    homepage = "https://salsa.debian.org/iso-codes-team/iso-codes";
    description = "Various ISO codes packaged as XML files";
    license = licenses.lgpl21;
    platforms = platforms.all;
    pkgConfigModules = [ "iso-codes" ];
  };
})
