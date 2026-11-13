{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hawkeye";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "fast";
    repo = "hawkeye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gI22g+cm3sOEoB/wWcDI9tSZZfuTg56Vp6eiGz3yX40=";
  };

  cargoHash = "sha256-eRiEeRHcqAw0FB2sRiUIlzI0Z5Rzgnv8PtFHAan53Ks=";

  cargoBuildFlags = [ "--package=hawkeye" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  logLevel = "warn";

  nativeCheckInputs = [
    gitMinimal
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/fast/hawkeye";
    changelog = "https://github.com/fast/hawkeye/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "License header checker and formatter";
    license = lib.licenses.asl20;
    mainProgram = "hawkeye";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
