{ lib
, boost
, cmake
, cxxopts
, digestpp
, fetchFromGitHub
, fmt
, jsoncons
, pugixml
, sqlite_orm
, stdenv
}:
stdenv.mkDerivation {
  pname = "bt-migrate";
  version = "0-unstable-2023-08-17";

  src = fetchFromGitHub {
    owner = "mikedld";
    repo = "bt-migrate";
    rev = "e15a489c0c76f98355586ebbee08223af4e9bf50";
    hash = "sha256-kA6yxhbIh3ThmgF8Zyoe3I79giLVmdNr9IIrw5Xx4s0=";
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

  meta = with lib; {
    description = "Torrent state migration tool";
    homepage = "https://github.com/mikedld/bt-migrate?tab=readme-ov-file";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "BtMigrate";
    platforms = platforms.all;
  };
}
