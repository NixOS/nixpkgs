{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "once";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "closure-labs";
    repo = "once";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W/yA/0+USGRfJLwzmR8daaD0wF6LuEOXblnO7Itlv+U=";
  };

  cargoHash = "sha256-k+xAuO8VWHDCMCsVD9jeZEq9RQYH3HLpJDfoSoUXD1Y=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Recognize accepted Nix build-trace realizations";
    homepage = "https://github.com/closure-labs/once";
    changelog = "https://github.com/closure-labs/once/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ declarative-dale ];
    mainProgram = "once";
    platforms = lib.platforms.linux;
  };
})
