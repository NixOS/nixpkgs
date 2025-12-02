{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-hack";
  version = "0.6.39";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-0+2bgjCgkZA8oYo5jkykB2US+LVVNo1tVk4smxYB6f4=";
  };

  cargoHash = "sha256-Pn7QL1D4WNMwCbXcm2bEdN2htIMwQhCsXrSaeeK2F7M=";

  # some necessary files are absent in the crate version
  doCheck = false;

  # versionCheckHook doesn't support multiple arguments yet
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/cargo-hack hack --version | grep -F 'cargo-hack ${finalAttrs.version}'
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ defelo ];
  };
})
