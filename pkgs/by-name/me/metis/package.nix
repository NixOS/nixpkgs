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
    tag = "v${finalAttrs.version}";
    hash = "sha256-eddLR6DvZ+2LeR0DkknN6zzRvnW+hLN2qeI+ETUPcac=";
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
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
