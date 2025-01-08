{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  fmt,
  spdlog,
  tl-expected,
  nlohmann_json,
  yaml-cpp,
  simdjson,
  reproc,
  libsolv,
  curl,
  libarchive,
  zstd,
  nix-update-script,
  bzip2,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmamba";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    rev = "libmamba-${finalAttrs.version}";
    hash = "sha256-UzuWQOFvp6KFDwcjjiwl0ek7pLuPvOijksUxp+hk/NU=";
  };

  nativeBuildInputs = [
    cmake
    python3Packages.python
  ];

  buildInputs = [
    fmt
    spdlog
    tl-expected
    nlohmann_json
    yaml-cpp
    simdjson
    reproc
    libsolv
    curl
    libarchive
    zstd
    bzip2
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIBMAMBA" true)
    (lib.cmakeBool "BUILD_SHARED" true)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for the fast Cross-Platform Package Manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
})
