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
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "alive2";
  version = "0-unstable-2024-09-23";

  src = fetchFromGitHub {
    owner = "AliveToolkit";
    repo = "alive2";
    rev = "05a964284056b38a6dc1f807e7acad64a0308328";
    sha256 = "sha256-okKKUU7WLXLD9Hvsfoz+1HQWoyQ/bqRpBk5ogr7kSJA=";
  };

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    re2c
    z3
    hiredis
    llvm_18
    ninja
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
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

  meta = {
    description = "Automatic verification of LLVM optimizations";
    homepage = "https://github.com/AliveToolkit/alive2";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
    mainProgram = "alive";
  };
})
