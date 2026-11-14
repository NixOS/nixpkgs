{
  bzip2,
  cli11,
  cmake,
  lib,
  libmamba,
  msgpack-c,
  nlohmann_json,
  python3,
  reproc,
  spdlog,
  stdenv,
  tl-expected,
  versionCheckHook,
  yaml-cpp,
  zstd,
}:
stdenv.mkDerivation {
  pname = "mamba-cpp";
  inherit (libmamba) version src;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    bzip2
    cli11
    libmamba
    msgpack-c
    nlohmann_json
    python3
    reproc
    spdlog
    tl-expected
    yaml-cpp
    zstd
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_MAMBA" true)
    (lib.cmakeBool "BUILD_SHARED" true)
    (lib.cmakeBool "BUILD_LIBMAMBA" false)
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Reimplementation of the conda package manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ klchen0112 ];
    mainProgram = "mamba";
  };
}
