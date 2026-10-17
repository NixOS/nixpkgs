{
  lib,
  stdenv,
  fetchFromGitHub,
  boost186,
  cmake,
  gitMinimal,
  openssl,
}:
let
  # keep consistent with cmake/Dependencies.cmake
  boost = boost186;
  libtorrent-src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "740a0b9aeabe00e762cc0efe4a0f27593db2550b";
    hash = "sha256-JbNOKzB830VQkZjC8ZAmzbu/7nkAgyD8cOr22uYbIGQ=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nuvio-engine";
  version = "0.1.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NuvioMedia";
    repo = "nuvio-engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PQYDZAPtG56FNu51VEHuen/Pk4j6ZuEhi0EE7UM4OzQ=";
  };

  postUnpack = ''
    cp -r --no-preserve=mode ${libtorrent-src} libtorrent
  '';

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    cmake
    gitMinimal
  ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NUVIO_BOOST" "${lib.getDev boost}/include")
    (lib.cmakeBool "NUVIO_ENGINE_BUILD_SHARED" true)
    (lib.cmakeBool "NUVIO_ENGINE_ENABLE_LIBTORRENT" true)
    (lib.cmakeBool "NUVIO_ENGINE_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];
  preConfigure = ''
    appendToVar cmakeFlags "-DFETCHCONTENT_SOURCE_DIR_NUVIO_LIBTORRENT=$NIX_BUILD_TOP/libtorrent"
  '';

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru = {
    inherit libtorrent-src;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Cross-platform torrent streaming engine";
    homepage = "https://github.com/NuvioMedia/nuvio-engine";
    changelog = "https://github.com/NuvioMedia/nuvio-engine/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
