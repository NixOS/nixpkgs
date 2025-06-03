{
  lib,
  stdenv,
  fetchFromGitHub,
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
stdenv.mkDerivation rec {
  pname = "mamba-cpp";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    tag = version;
    hash = "sha256-JBwdfYM7J5R7HZyw5kVXwu4FlZUd2QPrsTaGuXnyAJI=";
  };

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

  meta = with lib; {
    description = "Reimplementation of the conda package manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ klchen0112 ];
    mainProgram = "mamba";
  };
}
