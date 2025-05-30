{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "obj2tiles";
  version = "1.0.13";
  src = fetchFromGitHub {
    owner = "OpenDroneMap";
    repo = "Obj2Tiles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GLMLBmkVhuh8iYAxjD2XXnOvkw8dMuKTH49vvvSNHBI=";
  };
  projectFile = "Obj2Tiles/Obj2Tiles.csproj";
  nugetDeps = ./deps.json;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/Obj2Tiles";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  meta = {
    description = "Converts OBJ files to OGC 3D tiles by performing splitting, decimation and conversion";
    homepage = "https://github.com/OpenDroneMap/Obj2Tiles";
    changelog = "https://github.com/OpenDroneMap/Obj2Tiles/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mapperfr ];
    mainProgram = "Obj2Tiles";
  };
})
