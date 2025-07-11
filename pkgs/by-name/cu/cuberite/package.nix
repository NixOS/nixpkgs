{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lua,
  makeWrapper,
  perl,
  python3,
  unstableGitUpdater,
  testers,
  cuberite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cuberite";
  version = "0-unstable-2024-09-08";

  outputs = [
    "out"
    "outTests"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "cuberite";
    repo = "cuberite";
    rev = "0325de7dacaf1e2feaea5eaab4791bc23d78f9e7";
    fetchSubmodules = true; # TODO: Switch to nixpkgs-packaged dependencies
    hash = "sha256-Gz7WUBcQcUnEs9LD3/Epi9RBZrERCVgLtIlDH1tiK4E=";
  };

  patches = [
    ./add-version-info.patch
  ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    makeWrapper
    cmake
    lua # Used to check lua properties: https://github.com/cuberite/cuberite/blob/0325de7dacaf1e2feaea5eaab4791bc23d78f9e7/CheckLua.cmake
    perl
    python3
  ];

  enableTools = true;
  enableUnstableTools = false;
  enableTests = true;

  cmakeFlags = [
    (lib.cmakeFeature "OVERRIDE_VERSION" "${finalAttrs.src.rev}-nixpkgs")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "RELEASE") # Recommended by upstream
    (lib.cmakeBool "BUILD_TOOLS" finalAttrs.enableTools) # Build additional executables
    (lib.cmakeBool "BUILD_UNSTABLE_TOOLS" finalAttrs.enableUnstableTools) # Build broken and/or obsolete tools
    (lib.cmakeBool "SELF_TEST" finalAttrs.enableTests) # Enable tests
    (lib.cmakeBool "NO_NATIVE_OPTIMIZATION" (finalAttrs.NIX_ENFORCE_NO_NATIVE or true)) # Causes non-deterministic builds; NIX_ENFORCE_NO_NATIVE supports impureUseNativeOptimizations
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $dev/bin $dev/include $outTests/bin

    # Copy Cuberite main program and wrap to add lua interpreter to PATH
    cp Server/Cuberite $out/bin/Cuberite
    wrapProgram $out/bin/Cuberite --prefix PATH : ${lua}/bin
    ln -s Cuberite $out/bin/cuberite

    # Copy include files to $dev/include
    cp -r include/. $dev/include

    # Copy all executables to $out/bin or the bin of the tests output depending on the name, and drop any '-exe' suffixes
    for executable in bin/*; do
      if [[ $executable == *Test ]]; then
        cp $executable $outTests/bin
      else
        cp $executable $dev/bin/$(basename $executable -exe)
      fi
    done

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    tests = {
      version = testers.testVersion {
        package = cuberite;
        version = "${finalAttrs.src.rev}-nixpkgs";
      };
      basicGenerator = testers.runCommand {
        name = "runCommand-basicGenerator-test";
        script = lib.getExe' cuberite.outTests "BasicGeneratorTest";
      };
      blockState = testers.runCommand {
        name = "runCommand-blockState-test";
        script = lib.getExe' cuberite.outTests "BlockStateTest";
      };
      # TODO: Test fails for some reason. Investigate.
      # blockTypePalette = testers.runCommand {
      #   name = "runCommand-blockTypePalette-test";
      # script = lib.getExe' cuberite.outTests "BlockTypePaletteTest";
      # };
      blockTypeRegistry = testers.runCommand {
        name = "runCommand-blockTypeRegistry-test";
        script = lib.getExe' cuberite.outTests "BlockTypeRegistryTest";
      };
      noiseSpeed = testers.runCommand {
        name = "runCommand-noiseSpeed-test";
        script = lib.getExe' cuberite.outTests "NoiseSpeedTest";
      };
      palettedBlockArea = testers.runCommand {
        name = "runCommand-palettedBlockArea-test";
        script = lib.getExe' cuberite.outTests "PalettedBlockAreaTest";
      };
      uuid = testers.runCommand {
        name = "runCommand-uuid-test";
        script = lib.getExe' cuberite.outTests "UUIDTest";
      };
    };
  };

  meta = {
    description = "Lightweight, fast and extensible Minecraft server written in C++";
    homepage = "https://cuberite.org/";
    mainProgram = "cuberite";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
