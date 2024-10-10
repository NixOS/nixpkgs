{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lua,
  perl,
  python3,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cuberite";
  version = "0-unstable-2024-09-08";

  src = fetchFromGitHub {
    owner = "cuberite";
    repo = "cuberite";
    rev = "0325de7dacaf1e2feaea5eaab4791bc23d78f9e7";
    fetchSubmodules = true; # TODO: Switch to nixpkgs-packaged dependencies
    hash = "sha256-Gz7WUBcQcUnEs9LD3/Epi9RBZrERCVgLtIlDH1tiK4E=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    lua
    perl
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "RELEASE") # Recommended by upstream
    (lib.cmakeBool "BUILD_TOOLS" true) # Build additional executables
    (lib.cmakeBool "SELF_TEST" true) # Enable tests
    (lib.cmakeBool "NO_NATIVE_OPTIMIZATION" (finalAttrs.NIX_ENFORCE_NO_NATIVE or true)) # Causes non-deterministic builds; NIX_ENFORCE_NO_NATIVE supports impureUseNativeOptimizations
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/bin/test $out/include

    # Copy Cuberite main program
    cp Server/Cuberite $out/bin/Cuberite

    # Copy all executables to bin or bin/test depending on the name, and drop any '-exe' suffixes
    for executable in bin/*; do
      if [[ $executable == *Test ]]; then
        cp $executable $out/bin/test
      else
        cp $executable $out/bin/$(basename $executable -exe)
      fi
    done

    cp -r include/. $out/include

    runHook postInstall
  '';

  # TODO: Add passthru.tests
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Lightweight, fast and extensible Minecraft server written in C++";
    homepage = "https://cuberite.org/";
    mainProgram = "Cuberite";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
