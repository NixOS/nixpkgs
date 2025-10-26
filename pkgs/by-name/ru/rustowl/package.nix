{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustowl";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "cordx56";
    repo = "rustowl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pCeVLTiZk2Pv00AK2JlZ1kHrOX1V9iGNaJCdx7hIL+8=";
  };

  postPatch = ''
    substituteInPlace lua/rustowl/config.lua \
      --replace-fail \
        "cmd = { 'rustowl' }," \
        "cmd = { '${placeholder "out"}/bin/rustowl' }," \
  '';

  cargoHash = "sha256-Y8ZBwW2UKp0lVJm54vs9Ll9rEJcNqrEBE5pWH1nTjrM=";

  env = {
    RUSTUP_TOOLCHAIN = "stable";

    # Bypass rust nightly features not being available on rust stable
    RUSTC_BOOTSTRAP = 1;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visualize Ownership and Lifetimes in Rust";
    homepage = "https://github.com/cordx56/rustowl";
    changelog = "https://github.com/cordx56/rustowl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "rustowl";
  };
})
