{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "godotpcktool";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "hhyyrylainen";
    repo = "GodotPckTool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jQ6LypQEz7r04lS4Zmu0EvpV/IYM79pmUlaykVUd+po=";
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
