{
  lib,
  emmylua-ls,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_formatter";
  inherit (emmylua-ls) version src cargoHash;

  __structuredAttrs = true;
  strictDeps = true;

  buildAndTestSubdir = "crates/emmylua_formatter";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/luafmt";
  doInstallCheck = true;

  meta = {
    description = "Lua and EmmyLua formatter used by the EmmyLua Analyzer Rust workspace.";
    homepage = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust";
    changelog = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "luafmt";
  };
})
