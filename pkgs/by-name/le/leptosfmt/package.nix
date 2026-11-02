{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leptosfmt";
  version = "0.1.33";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    tag = finalAttrs.version;
    hash = "sha256-+trLQFU8oP45xHQ3DsEESQzQX2WpvQcfpgGC9o5ITcY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-m9426zuxp9GfbYoljW49BVgetLTqqcqGHCb7I+Yw+bc=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter for the leptos view! macro";
    mainProgram = "leptosfmt";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
