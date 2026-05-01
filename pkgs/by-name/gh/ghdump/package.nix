{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghdump";
  version = "0.1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "ghdump";
    tag = finalAttrs.version;
    hash = "sha256-ozOWbncNN+Jq9jJpbHvjrIIsx5+R/hzBqQvqfoxH5ZA=";
  };

  cargoHash = "sha256-G24vq74B8NyRq++FlyvR946MWKE0x1n1phTfxFSF8Gs=";

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
