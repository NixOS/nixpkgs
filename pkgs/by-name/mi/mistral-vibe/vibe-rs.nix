{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  alsa-lib,
  oniguruma,
  cacert,
  coreutils,
  gitMinimal,

  version,
  src,
  meta,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vibe-rs";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/vibe/cli-rust";

  cargoHash = "sha256-BlLq0rCFmDTK11f9dam8Fc/kJVNqa82C/L6UKKG0+M0=";

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

  # Fake clipboard tools in the tests call `/bin/cat`, which is absent from the sandbox
  postPatch = ''
    substituteInPlace tests/isolated/clipboard_linux.rs \
      --replace-fail \
        "/bin/cat" \
        "${lib.getExe' coreutils "cat"}"
  '';

  nativeCheckInputs = [
    # reqwest (sentry) fails to build without CA certificates
    cacert
    gitMinimal
  ];

  # The `isolated` test target needs one process per test
  useNextest = true;

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
