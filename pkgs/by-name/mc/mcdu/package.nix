{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcdu";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mikalv";
    repo = "mcdu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTEA4baUTLoMrYMoF6V0rOCqHo1g1Zs8iA3CIp1F7zQ=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-9dtiJjpXDjDsZjiHFoyZ8QWlH+MK6i00f5fQ87EVXe4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI disk usage analyzer and developer cleanup tool";
    homepage = "https://github.com/mikalv/mcdu";
    changelog = "https://github.com/mikalv/mcdu/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jtrv ];
    mainProgram = "mcdu";
  };
})
