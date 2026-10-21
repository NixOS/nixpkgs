{
  lib,
  stdenv,
  fetchurl,
  gettext,
  meson,
  ninja,
  python3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iso-codes";
  version = "4.20.1";

  src = fetchurl {
    url =
      with finalAttrs;
      "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v${version}/iso-codes-v${version}.tar.gz";
    hash = "sha256-LX2fYISrnObFNM5xo91RRLbkdPPJdhZFmoj3P0SmS/8=";
  };

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    gettext
    meson
    ninja
    python3
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://salsa.debian.org/iso-codes-team/iso-codes";
    description = "Various ISO codes packaged as XML files";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "iso-codes" ];
  };
})
