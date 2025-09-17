{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iroh-doctor";
  version = "0.91.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh-doctor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5ncCYBKMbxSsPUTkmBaK23MAPFQi5Tj+CwfujJPuBbQ=";
  };

  cargoHash = "sha256-M0mGA03DaoyTn7vjevFN640tctnvw/994viaiOsoArk=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for testing iroh connectivity";
    homepage = "https://github.com/n0-computer/iroh-doctor";
    license = with lib.licenses; [
      asl20 # OR
      mit
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "iroh-doctor";
  };
})
