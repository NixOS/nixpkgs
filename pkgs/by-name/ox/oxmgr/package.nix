{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  apple-sdk_15,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxmgr";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Vladimir-Urik";
    repo = "OxMgr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uh/HwbRRtMAxWD1xwgFK0PtCQbMeKn7p3PP/FtiLNoo=";
  };

  cargoHash = "sha256-Ti0KWdPP6U8wr8vdZP9gx7uj7Ew1/IRDE6vFDBDNzXI=";

  nativeCheckInputs = [
    gitMinimal
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Lightweight language-agnostic process manager";
    homepage = "https://oxmgr.empellio.com";
    changelog = "https://github.com/Vladimir-Urik/OxMgr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b6d5b38e0d7ae6bd0d951815cd92df43 ];
    mainProgram = "oxmgr";
  };
})
