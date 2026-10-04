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

  cargoHash = "sha256-LGEjJuTBdoUR83Q5UeNKahJTwkxQIm8S9d+l/KDKpnc=";

  nativeBuildInputs = [
    pkg-config
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
