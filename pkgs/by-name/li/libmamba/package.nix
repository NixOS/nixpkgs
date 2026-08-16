{
  bzip2,
  cmake,
  curl,
  fetchFromGitHub,
  fmt,
  lib,
  libarchive,
  libsolv,
  msgpack-c,
  nix-update-script,
  nlohmann_json,
  python3,
  reproc,
  simdjson,
  spdlog,
  stdenv,
  tl-expected,
  yaml-cpp,
  zstd,
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
    bzip2
    curl
    fmt
    libarchive
    libsolv
    msgpack-c
    nlohmann_json
    reproc
    simdjson
    spdlog
    tl-expected
    yaml-cpp
    zstd
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIBMAMBA" true)
    (lib.cmakeBool "BUILD_LIBMAMBA_SPDLOG" true)
    (lib.cmakeBool "BUILD_SHARED" true)
  ];

  __structuredAttrs = true;
  strictDeps = true;

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
