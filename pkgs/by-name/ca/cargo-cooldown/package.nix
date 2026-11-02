{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-cooldown";
  version = "0.3.5";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-knBFIncQzePHA4ByxJ1f32OemUGRJTpFyW7VPPs7S6M=";
  };

  cargoHash = "sha256-8NzNpnYRxnTDo7AUxEK7zBAoZcktMxM/8EqeiFpfBds=";

  # Integration tests and some unit tests require network access (crates.io registry) which breaks
  # in the Nix sandbox.
  cargoTestFlags = [ "--bin=cargo-cooldown" ]; # Focus on binary tests, skip integration tests
  checkFlags = [ "--skip=lockfile::tests" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cargo wrapper that enforces a cooldown window for freshly published registry crates for improved supply chain security";
    mainProgram = "cargo-cooldown";
    homepage = "https://github.com/dertin/cargo-cooldown";
    changelog = "https://github.com/dertin/cargo-cooldown/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ bew ];
  };
})
