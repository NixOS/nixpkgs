{
  fetchFromGitHub,
  glib,
  lib,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-packager";
  version = "0.11.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crabnebula-dev";
    repo = "cargo-packager";
    tag = "cargo-packager-v${finalAttrs.version}";
    hash = "sha256-D1jrcVzu8urlGFOn1VohOgTpgki9SfdV8IVVWBS78BA=";
  };

  cargoHash = "sha256-GDIJLaeFVM0RHLogN85XwwzdIDyGcgqv/q3whayhqPg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib ];

  cargoBuildFlags = [
    "--package"
    "cargo-packager"
  ];

  cargoTestFlags = [
    "--package"
    "cargo-packager"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "cargo-packager-v(.*)"
    ];
  };

  meta = {
    description = "Rust executable packager, bundler and updater";
    homepage = "https://docs.crabnebula.dev/packager/";
    changelog = "https://github.com/crabnebula-dev/cargo-packager/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "cargo-packager";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.all;
  };
})
