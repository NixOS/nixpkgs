{
  lib,
  stdenv,
  bzip2,
  cmake,
  cli11,
  yaml-cpp,
  nlohmann_json,
  zstd,
  reproc,
  spdlog,
  tl-expected,
  libmamba,
  python3,
  versionCheckHook,
}:
stdenv.mkDerivation {
  pname = "mamba-cpp";
  inherit (libmamba) version src;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    python3
    reproc
    spdlog
    nlohmann_json
    tl-expected
    zstd
    bzip2
    cli11
    yaml-cpp
    libmamba
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_MAMBA" true)
    (lib.cmakeBool "BUILD_SHARED" true)
    (lib.cmakeBool "BUILD_LIBMAMBA" false)
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Reimplementation of the conda package manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ klchen0112 ];
=======
  meta = with lib; {
    description = "Reimplementation of the conda package manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ klchen0112 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mamba";
  };
}
