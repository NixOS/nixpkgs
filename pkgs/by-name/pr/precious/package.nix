{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "precious";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "houseabsolute";
    repo = "precious";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xM4NqcT1NGR3tkLOPt59lfFpjRnohU+tTTk9Ijkf97o=";
  };

  cargoHash = "sha256-tp0kvG5G7mW0czfZ43AbT7Lcv1sMnO5Zc+t2d5w4aqA=";

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
