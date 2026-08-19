{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rainfrog";
  version = "0.4.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PQB/wuLh2iRTlKIwAJ8KfcMJUtHHDkIQXcd2GkorKeI=";
  };

  cargoHash = "sha256-0HQszMKfmt93wi+HnZigKPssoDXfpV9BfQJgfG/geEw=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/achristmascarl/rainfrog/releases/tag/v${finalAttrs.version}";
    description = "Database management TUI for postgres";
    homepage = "https://github.com/achristmascarl/rainfrog";
    license = lib.licenses.mit;
    mainProgram = "rainfrog";
    maintainers = with lib.maintainers; [ patka ];
  };
})
