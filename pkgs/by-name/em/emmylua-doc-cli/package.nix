{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_doc_cli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
    hash = "sha256-HbjGOvK/b7SyhNF/Jff0SgJdOfSbzjkDkqQwuflOABA=";
  };

  buildAndTestSubdir = "crates/emmylua_doc_cli";

  cargoHash = "sha256-3x71VNWCTFb75STx8w/T++dLo1s2FwNhFm+lyZHS7qI=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/emmylua_doc_cli";
  versionCheckProgramArg = "--version";
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
