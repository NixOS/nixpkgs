{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  alsa-lib,
  oniguruma,
  cacert,
  gitMinimal,

  version,
  src,
  meta,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vibe-rs";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/vibe/cli-rust";

  cargoHash = "sha256-eXXStcKbwCjTXauBP504UrKX6GNq6KWdL+qr8TK9KpE=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Needed to build `coreaudio-sys` (pulled by `cpal`)
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    oniguruma
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

  nativeCheckInputs = [
    # reqwest (sentry) fails to build without CA certificates
    cacert
    gitMinimal
  ];

  # Tests spin up mock HTTP servers on 127.0.0.1
  __darwinAllowLocalNetworking = true;

  cargoBuildFlags = [
    "--bin"
    "vibe-rs"
  ];

  meta = {
    description = "Rust TUI for Mistral Vibe";
    inherit (meta)
      homepage
      changelog
      license
      maintainers
      ;
    mainProgram = "vibe-rs";
  };
})
