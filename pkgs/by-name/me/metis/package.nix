{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metis";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "METIS";
    tag = finalAttrs.version;
  };

  cmakeFlags = [
    (lib.cmakeFeature "GKLIB_PATH" "../GKlib")
  ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Serial graph partitioning and fill-reducing matrix ordering";
    homepage = "https://karypis.github.io/glaros/software/metis/overview.html";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
