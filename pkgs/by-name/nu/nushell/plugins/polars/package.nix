{
  stdenv,
  lib,
  rustPlatform,
  openssl,
  nushell,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_polars";
  inherit (nushell) version src;

  # https://github.com/nushell/nushell/commit/1139611e188d5fc2b0264b8b24d7d38da160f05b
  cargoPatches = [ ./update-ethnum.patch ];
  cargoHash = "sha256-Cpv58bqpx1o0Dz2AykqzFY+PQE/Updr5MusQflpEF74=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = [ openssl ];

  buildAndTestSubdir = "crates/nu_plugin_polars";

  checkFlags = [
    "--skip=dataframe::command::core::to_repr::test::test_examples"
  ];

  passthru.updateScript = nix-update-script {
    # Skip the version check and only check the hash because we inherit version from nushell.
    extraArgs = [ "--version=skip" ];
  };

  meta = {
    description = "Nushell dataframe plugin commands based on polars";
    mainProgram = "nu_plugin_polars";
    homepage = "https://github.com/nushell/nushell/tree/${finalAttrs.version}/crates/nu_plugin_polars";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ joaquintrinanes ];
  };
})
