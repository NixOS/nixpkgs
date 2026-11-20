{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  directx-shader-compiler,
  ispc,
  ncurses,
  nix-update-script,
  openal,
  rapidjson,
  versionCheckHook,
  vulkan-headers,
  vulkan-loader,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rbdoom-3-bfg";
  version = "1.6.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RobertBeckebans";
    repo = "RBDOOM-3-BFG";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9BZEFO+e5IG6hv9+QI9OJecQ84rLTWBDz4k0GU6SeDE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace neo/extern/ShaderMake/CMakeLists.txt \
      --replace-fail "AppleClang" "Clang"
  '';

  nativeBuildInputs = [
    cmake
    directx-shader-compiler
    ispc
  ];

  buildInputs = [
    ncurses
    openal
    rapidjson
    SDL2
    vulkan-headers
    vulkan-loader
    zlib
  ];

  cmakeDir = "../neo";

  cmakeFlags = [
    (lib.cmakeBool "FFMPEG" false)
    (lib.cmakeBool "BINKDEC" true)
    (lib.cmakeBool "USE_SYSTEM_RAPIDJSON" true)
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
  ];

  buildFlags = [ "RBDoom3BFG" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 RBDoom3BFG -t $out/bin

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Doom 3 BFG Edition with modern engine features";
    homepage = "https://github.com/RobertBeckebans/RBDOOM-3-BFG";
    changelog = "https://github.com/RobertBeckebans/RBDOOM-3-BFG/blob/${finalAttrs.src.tag}/RELEASE-NOTES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Zaechus ];
    platforms = lib.platforms.unix;
    mainProgram = "RBDoom3BFG";
  };
})
