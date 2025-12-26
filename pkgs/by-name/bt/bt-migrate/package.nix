{
  lib,
  boost,
  cmake,
  cxxopts,
  digestpp,
  fetchFromGitHub,
  fmt,
  jsoncons,
  pugixml,
  sqlite_orm,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "bt-migrate";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "mikedld";
    repo = "bt-migrate";
    rev = "eb5b0ba5e0176844efde3a319595f52ffe900c2c";
    hash = "sha256-eg7rZnqpQiOA1N7GHv14eDAmvmj6VWq/dlw2YBw6IAA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    cxxopts
    fmt
    jsoncons
    pugixml
    sqlite_orm
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "USE_VCPKG" false)
    # NOTE: digestpp does not have proper CMake packaging (yet?)
    (lib.strings.cmakeBool "USE_FETCHCONTENT" true)
    (lib.strings.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DIGESTPP" "${digestpp}/include/digestpp")
  ];

  # NOTE: no install target in CMake...
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp BtMigrate $out/bin

    runHook postInstall
  '';

  strictDeps = true;

  meta = {
    description = "Torrent state migration tool";
    homepage = "https://github.com/mikedld/bt-migrate?tab=readme-ov-file";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "BtMigrate";
    platforms = lib.platforms.all;
  };
}
