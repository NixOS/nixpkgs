{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_ls";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
    hash = "sha256-HbjGOvK/b7SyhNF/Jff0SgJdOfSbzjkDkqQwuflOABA=";
  };

  buildAndTestSubdir = "crates/emmylua_ls";

  cargoHash = "sha256-3x71VNWCTFb75STx8w/T++dLo1s2FwNhFm+lyZHS7qI=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/emmylua_ls";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "EmmyLua Language Server";
    homepage = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust";
    changelog = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "emmylua_ls";
  };
})
