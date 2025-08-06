{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_doc_cli";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
    hash = "sha256-Fvg3G0C/YECDEWZ4mDC5b8qocWvyDJ9KdLYNtwIu0+I=";
  };

  buildAndTestSubdir = "crates/emmylua_doc_cli";

  cargoHash = "sha256-MIGYx1qMxsCCq3QkFeOuKbM4w/sJ2K0T+SRIDJQjf/8=";

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
