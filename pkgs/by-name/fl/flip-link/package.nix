{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flip-link";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = "flip-link";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HYNaHXgI02xY1/eBkwLPN1AGwO6w98tCjwvP8YinuxE=";
  };

  cargoHash = "sha256-hfDf3ipprKggoQ0xR66arRkBaXf4rntoRTgzvXjahUg=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  checkFlags = [
    # requires embedded toolchains
    "--skip=should_link_example_firmware::case_1_normal"
    "--skip=should_link_example_firmware::case_2_custom_linkerscript"
    "--skip=should_verify_memory_layout"
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script {
    # Ignore the stray flip-link-v0.1.12 tag upstream carries.
    extraArgs = [
      "--version-regex"
      "v([0-9.]+)"
    ];
  };

  meta = {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    mainProgram = "flip-link";
    homepage = "https://github.com/knurling-rs/flip-link";
    changelog = "https://github.com/knurling-rs/flip-link/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      FlorianFranzen
      newam
    ];
  };
})
