{
  lib,
  boost,
  ceres-solver,
  cgal,
  cmake,
  eigen,
  fetchFromGitHub,
  glfw,
  gmp,
  libjpeg,
  libpng,
  libtiff,
  mpfr,
  nix-update-script,
  llvmPackages,
  opencv,
  pkg-config,
  python3,
  stdenv,
  vcg,
  zstd,
}:

let
  boostWithZstd = boost.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ zstd ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.3.0";
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+0rz1O7pf9dUyfK0ESW4DFzrpBgDKZxQ/mmHoh8mh+0=";
  };

  # SSE is enabled by default
  cmakeFlags = lib.optionals (!stdenv.hostPlatform.isx86_64) [
    (lib.cmakeBool "OpenMVS_USE_SSE" false)
  ];

  buildInputs = [
    boostWithZstd
    ceres-solver
    cgal
    eigen
    glfw
    gmp
    libjpeg
    libpng
    libtiff
    mpfr
    opencv
    llvmPackages.openmp
    vcg
    python3
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postInstall = ''
    mv $out/bin/OpenMVS/* $out/bin
    rmdir $out/bin/OpenMVS
    rm $out/bin/Tests
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Multi-View Stereo reconstruction library";
    homepage = "https://github.com/cdcseacave/openMVS";
    changelog = "https://github.com/cdcseacave/openMVS/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bouk ];
  };
})
