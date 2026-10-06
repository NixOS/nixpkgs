{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "corrode-scanner";
  version = "0.5.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ul0gic";
    repo = "corrode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ucMNdl4TIl4TnGrkQXxO9ZNkYXrDD5Kto8NbWeT3IKI=";
  };

  cargoHash = "sha256-0iKzigRLfnepGs2DMnYEWA4FwfRUegu+i64EbE881Qs=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Security scanner for finding exposed credentials, secrets, and vulnerabilities";
    homepage = "https://github.com/ul0gic/corrode";
    changelog = "https://github.com/ul0gic/corrode/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "corrode-scanner";
  };
})
