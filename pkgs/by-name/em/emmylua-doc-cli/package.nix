{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_doc_cli";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
    hash = "sha256-IXoiXfRnGOZQ7c8AJaK8OGjqp1bczd/tKjtpbYdCZlU=";
  };

  buildAndTestSubdir = "crates/emmylua_doc_cli";

  cargoHash = "sha256-7QQipbnqelLdzQr+lIORyQNM9SS5yHaJLQ31M52lYCw=";

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
