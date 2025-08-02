{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "roblox-ts";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "roblox-ts";
    repo = "roblox-ts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LYpTx0FrTvyKsg9qW10lUvsVxMIiKQpYxWsBzWNG50c=";
  };

  npmDepsHash = "sha256-43Ay1dtDMxio0//pe+/WqIytNvdXWCNUhlef3wK4jWw=";

  # https://github.com/roblox-ts/roblox-ts/issues/2915
  patches = [ ./package-lock.json.patch ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/rbxtsc";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TypeScript-to-Luau Compiler for Roblox";
    homepage = "https://github.com/roblox-ts/roblox-ts";
    downloadPage = "https://github.com/roblox-ts/roblox-ts/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/roblox-ts/roblox-ts/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    mainProgram = "rbxtsc";
    platforms = lib.platforms.all;
  };
})
