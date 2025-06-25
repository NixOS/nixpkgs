{
  lib,
  clangStdenv,
  fetchFromGitHub,
  re2c,
  z3,
  hiredis,
  llvm_18,
  cmake,
  ninja,
  nix-update-script,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "alive2";
  version = "20.0";

  src = fetchFromGitHub {
    owner = "AliveToolkit";
    repo = "alive2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4QNrBRGH+rxXwb7zTRYAixxipN3ybcXuWCmO+BLU9r4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    re2c
  ];
  buildInputs = [
    z3
    hiredis
    llvm_18
  ];
  strictDeps = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '-Werror' "" \
      --replace-fail 'find_package(Git REQUIRED)' ""
  '';

  env = {
    ALIVE2_HOME = "$PWD";
    LLVM2_HOME = "${llvm_18}";
    LLVM2_BUILD = "$LLVM2_HOME/build";
  };

  preBuild = ''
    mkdir -p build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp alive $out/bin/
    cp alive-jobserver $out/bin/
    rm -rf $out/bin/CMakeFiles $out/bin/*.o
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatic verification of LLVM optimizations";
    homepage = "https://github.com/AliveToolkit/alive2";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    teams = [ lib.teams.ngi ];
    mainProgram = "alive";
  };
})
