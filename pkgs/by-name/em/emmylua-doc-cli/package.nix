{
  lib,
  emmylua-ls,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_doc_cli";
  inherit (emmylua-ls) version src;

  buildAndTestSubdir = "crates/emmylua_doc_cli";

  cargoHash = "sha256-JNirHIKXFsiLme5oByerHjB/3lumuAr2u3pNfxh4qa0=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/emmylua_doc_cli";
  doInstallCheck = true;

  meta = {
    description = "Professional documentation generator creating beautiful, searchable API docs from your Lua code and annotations.";
    homepage = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust";
    changelog = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "emmylua_doc_cli";
  };
})
