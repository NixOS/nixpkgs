{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "precious";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "houseabsolute";
    repo = "precious";
    tag = "v${finalAttrs.version}";
    hash = "sha256-moJk8bwMlYtfo+Iq/OcjJkQJQiirZ6oKSoATpW3KcQI=";
  };

  cargoHash = "sha256-nvHP5/njvkXcI3QtFU4CijXaX5l4DabMMVzvktvFNvA=";

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
