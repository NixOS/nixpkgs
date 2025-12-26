{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swaysome";
  version = "2.3.2";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = "swaysome";
    tag = finalAttrs.version;
    hash = "sha256-YD+OYoUz4ydOGZTB5qPnqamV4xO6QoJiyf27qx1SuoU=";
  };

  cargoHash = "sha256-cg8fCy2naqibuS5rGfgpFDBAr0EqOldQbejq4ctXJ/0=";

  # failed to execute sway: Os { code: 2, kind: NotFound, message: "No such file or directory" }
  doCheck = false;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ esclear ];
    platforms = lib.platforms.linux;
    mainProgram = "swaysome";
  };
})
