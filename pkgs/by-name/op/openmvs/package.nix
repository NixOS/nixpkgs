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
  version = "2.2.0";
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-j/tGkR73skZiU+bP4j6aZ5CxkbIcHtqKcaUTgNvj0C8=";
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
