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
  minimage,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "d-seams";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "d-SEAMS";
    repo = "seams-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9tLjz+HrdJN0Ok1ByH/URGDnfFMCxtDec0bsQpb1EC4=";
  };

  # Upstream disables libc++ availability checks for conda's newer libc++.
  # We link the system libc++, so the checks must stay on.
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "_args += ['-D_LIBCPP_DISABLE_AVAILABILITY']" ""
  '';

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
    minimage
  ];

  mesonFlags = [
    "-Dwith_gpulite=disabled"
    "-Dwith_ira=disabled"
    "-Dwith_sphericart=disabled"
    "-Dwith_nauty=disabled"
    "-Dwith_linkcell=disabled"
    "-Dwith_minimage=enabled"
  ];

  # A clathrate unit cell has a known number of cages: sI has 2 small (5^12),
  # sII has 16 small and 8 large (5^12 6^4).
  passthru.tests.cages =
    runCommand "d-seams-test-cages" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
      ''
        traj=${finalAttrs.src}/input/traj

        check() {
          echo "$1"
          [[ "$1" == *"cages $2 "* ]] || { echo "expected $2 cages"; exit 1; }
        }

        check "$(seams cages $traj/genice_sI.lammpstrj --graph cutoff --signature 512)" 2
        check "$(seams cages $traj/genice_sII.lammpstrj --graph cutoff --signature 512)" 16
        check "$(seams cages $traj/genice_sII.lammpstrj --graph cutoff --signature 51264)" 8

        touch $out
      '';

  meta = {
    description = "Deferred Structural Elucidation Analysis for Molecular Simulations";
    homepage = "https://dseams.info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "seams";
  };
})
