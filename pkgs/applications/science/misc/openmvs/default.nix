{ lib
, boost
, breakpad
, ceres-solver
, cgal
, cmake
, eigen
, fetchFromGitHub
, glfw
, gmp
, libjpeg
, libpng
, libtiff
, mpfr
, opencv
, openmp
, pkg-config
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
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-j/tGkR73skZiU+bP4j6aZ5CxkbIcHtqKcaUTgNvj0C8=";
=======
    sha256 = "sha256-eqNprBgR0hZnbLKLZLJqjemKxHhDtGblmaSxYlmegsc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    glfw
    gmp
    libjpeg
    libpng
    libtiff
    mpfr
    opencv
    openmp
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

  meta = {
    description = "Open Multi-View Stereo reconstruction library";
    homepage = "https://github.com/cdcseacave/openMVS";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bouk ];
  };
}
