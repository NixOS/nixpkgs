{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  eigen,
  blas,
  lapack,
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "d-seams";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "d-SEAMS";
    repo = "seams-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gtDD0Nc3pC+7eLtH8h+c7j1E9OSGwUWip+Nu0LTOEmw=";
  };

  doCheck = true;
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    eigen
    blas
    lapack
    catch2_3
  ];

  mesonFlags = [
    "-Dwith_gpulite=disabled"
    "-Dwith_ira=disabled"
    "-Dwith_sphericart=disabled"
    "-Dwith_nauty=disabled"
  ];

  meta = {
    description = "Deferred Structural Elucidation Analysis for Molecular Simulations";
    homepage = "https://dseams.info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.linux;
    mainProgram = "seams";
  };
})
