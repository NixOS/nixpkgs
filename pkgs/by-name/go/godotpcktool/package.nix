{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "godotpcktool";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "hhyyrylainen";
    repo = "GodotPckTool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v8etiUKVxSgVSB3ARqdLgbp3SEC12xBf0HXDl1RJRug=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Standalone tool for extracting and creating Godot .pck files";
    homepage = "https://github.com/hhyyrylainen/GodotPckTool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambossmann ];
    mainProgram = "godotpcktool";
    platforms = lib.platforms.linux;
  };
})
