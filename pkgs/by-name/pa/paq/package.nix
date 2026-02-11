{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paq";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "gregl83";
    repo = "paq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L9hjTdpV7j1qKX9GSo9Nb+nA1mPKz2aftAquiBuUbn4=";
  };

  cargoHash = "sha256-LjAPCdPZI/qGISb4/kY2fRG0G0d/VwHeISAmfZSF4sI=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash file or directory recursively";
    homepage = "https://github.com/gregl83/paq";
    changelog = "https://github.com/gregl83/paq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "paq";
  };
})
