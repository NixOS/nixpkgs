{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "precious";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "houseabsolute";
    repo = "precious";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yst+Z64WdgAfCbtt8R7ATzvUEY772ndtptyvFf/UkAk=";
  };

  cargoHash = "sha256-DRR1EQIbJWDzBAZIXhUk0oQ24SvPwamWh5tsUkeBdqs=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "One code quality tool to rule them all";
    homepage = "https://github.com/houseabsolute/precious";
    changelog = "https://github.com/houseabsolute/precious/releases/tag/v${finalAttrs.version}";
    mainProgram = "precious";
    maintainers = with lib.maintainers; [ abhisheksingh0x558 ];
    license = with lib.licenses; [
      mit # or
      asl20
    ];
  };
})
