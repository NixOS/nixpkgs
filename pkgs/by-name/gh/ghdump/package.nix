{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghdump";
  version = "0.2.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "ghdump";
    tag = finalAttrs.version;
    hash = "sha256-UNIG/AT5RGPeNfZ7S3TdhfN+s8VXRPygcTBV7Fulilg=";
  };

  cargoHash = "sha256-gyNMtS6h2ct9IkvfhRWyMv9JVPtVEILsmYUcPETFEWQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/drupol/ghdump/releases/tag/${finalAttrs.version}";
    description = "Export GitHub issues, pull requests, and discussions through customizable templates";
    homepage = "https://github.com/drupol/ghdump";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "ghdump";
  };
})
