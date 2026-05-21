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
  msgpack-c,
  libarchive,
  zstd,
  nix-update-script,
  bzip2,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmamba";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    tag = finalAttrs.version;
    hash = "sha256-qvUo2OD+vh5oXF/ckz9vJyiQ9wpEbTrC+C4oYXOGFAU=";
  };

  nativeBuildInputs = [
    cmake
    python3
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
    msgpack-c
    libarchive
    zstd
    bzip2
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIBMAMBA" true)
    (lib.cmakeBool "BUILD_LIBMAMBA_SPDLOG" true)
    (lib.cmakeBool "BUILD_SHARED" true)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mamba-org/mamba/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Library for the fast Cross-Platform Package Manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
})
