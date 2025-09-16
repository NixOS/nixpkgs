{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_check";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
    hash = "sha256-93PlsVvlUravsnW7YBCii04jCEJPP+6U2vYbVBjcX8M=";
  };

  buildAndTestSubdir = "crates/emmylua_check";

  cargoHash = "sha256-SbsYlIVWDpBU2bxJqXUtOiMHkOoa8Up27X7rVKLLLm0=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/emmylua_check";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Comprehensive Lua static analysis tool for code quality assurance";
    homepage = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust";
    changelog = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "emmylua_check";
  };
})
