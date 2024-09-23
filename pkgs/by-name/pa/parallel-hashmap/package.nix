{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parallel-hashmap";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "greg7mdp";
    repo = "parallel-hashmap";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-19rWcnMtWgqYlLylUjgI/p3aAM0Ois3CKoMuMmLQHmM=";
  };

  postPatch = ''
    # don't download googletest, but build it from source
    # https://github.com/greg7mdp/parallel-hashmap/blob/be6a2c79857c9ea76760ca6ce782e1609713428e/CMakeLists.txt#L98
    substituteInPlace CMakeLists.txt \
      --replace "include(cmake/DownloadGTest.cmake)" "add_subdirectory(${gtest.src} ./googletest-build EXCLUDE_FROM_ALL)"
  '';

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DPHMAP_BUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DPHMAP_BUILD_EXAMPLES=OFF"
  ];

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  meta = with lib; {
    description = "Family of header-only, very fast and memory-friendly hashmap and btree containers";
    homepage = "https://github.com/greg7mdp/parallel-hashmap";
    changelog = "https://github.com/greg7mdp/parallel-hashmap/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ natsukium ];
  };
})
