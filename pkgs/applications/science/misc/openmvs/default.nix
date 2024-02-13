{ lib
, boost
, breakpad
, ceres-solver
, cgal
, cmake
, eigen
, fetchFromGitHub
, glew
, glfw
, gmp
, libjpeg
, libpng
, libtiff
, mpfr
, nix-update-script
, opencv
, openmp
, pkg-config
, python3
, stdenv
, vcg
, zstd
}:

let
  boostWithZstd = boost.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ zstd ];
  });
in
stdenv.mkDerivation rec {
  version = "2.3.0";
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    rev = "v${version}";
    hash = "sha256-+0rz1O7pf9dUyfK0ESW4DFzrpBgDKZxQ/mmHoh8mh+0=";
    fetchSubmodules = true;
  };

  # SSE is enabled by default
  cmakeFlags = lib.optional (!stdenv.isx86_64) "-DOpenMVS_USE_SSE=OFF";

  buildInputs = [
    boostWithZstd
    breakpad
    ceres-solver
    cgal
    eigen
    glew
    glfw
    gmp
    libjpeg
    libpng
    libtiff
    mpfr
    opencv
    openmp
    python3
    vcg
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  postInstall = ''
    mv $out/bin/OpenMVS/* $out/bin
    rmdir $out/bin/OpenMVS
    rm $out/bin/Tests
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ctest
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Multi-View Stereo reconstruction library";
    homepage = "https://github.com/cdcseacave/openMVS";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bouk ];
  };
}
