{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kokkos";
  version = "4.6.02";

  src = fetchFromGitHub {
    owner = "kokkos";
    repo = "kokkos";
    rev = finalAttrs.version;
    hash = "sha256-gpnaxQ3X+bqKiP9203I1DELDGXocRwMPN9nHFk5r6pM=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "Kokkos_ENABLE_TESTS" true)
  ];

  postPatch = ''
    patchShebangs .
  '';

  doCheck = true;
  passthru.updateScript = gitUpdater { };

  meta = {
    description = "C++ Performance Portability Programming EcoSystem";
    homepage = "https://github.com/kokkos/kokkos";
    changelog = "https://github.com/kokkos/kokkos/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ Madouura ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
