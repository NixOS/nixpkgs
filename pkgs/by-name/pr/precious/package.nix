{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "precious";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "houseabsolute";
    repo = "precious";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bHrn78wzdkxV92Lp3MzNUpSvMTyc8l3tw+z5NBxJPoA=";
  };

  cargoHash = "sha256-OA1C98C0BHEVl056UCL5alT292djuBDGFjZn2HAytEQ=";

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
