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
  libjxl,
  libjpeg,
  libpng,
  libtiff,
  mpfr,
  nanoflann,
  nix-update-script,
  llvmPackages,
  opencv,
  pkg-config,
  python3Packages,
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
  version = "2.4.0";
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0tL2tqHYBQMGL9k+NqTUxieWuDP3YB6X9DcXYnlGWWg=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'FIND_PACKAGE(Boost REQUIRED COMPONENTS iostreams program_options system serialization OPTIONAL_COMPONENTS ''${Boost_EXTRA_COMPONENTS})' \
      'FIND_PACKAGE(Boost REQUIRED COMPONENTS iostreams program_options serialization OPTIONAL_COMPONENTS ''${Boost_EXTRA_COMPONENTS})'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "Python3_EXECUTABLE" (lib.getExe python3Packages.python))
  ]
  # SSE is enabled by default
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
    (lib.cmakeBool "OpenMVS_USE_SSE" false)
  ];

  buildInputs = [
    boostWithZstd
    ceres-solver
    cgal
    eigen
    glfw
    gmp
    libjxl
    libjpeg
    libpng
    libtiff
    mpfr
    nanoflann
    opencv
    llvmPackages.openmp
    vcg
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
  ];

  postInstall = ''
    mv $out/bin/OpenMVS/* $out/bin
    rmdir $out/bin/OpenMVS
    rm $out/bin/Tests
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ${lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
      export KMP_AFFINITY=disabled
      export OMP_PROC_BIND=false
    ''}
    ctest --output-on-failure
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Multi-View Stereo reconstruction library";
    homepage = "https://github.com/cdcseacave/openMVS";
    changelog = "https://github.com/cdcseacave/openMVS/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bouk
      miniharinn
    ];
  };
})
