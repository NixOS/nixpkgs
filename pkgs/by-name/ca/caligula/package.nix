{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caligula";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2KCP7Utb785yIn8w/Ls19UPS9ylg1PtLRki87+BD+xw=";
  };

  cargoHash = "sha256-C86wu2Pc9O7YM1TnnfotzzOQlnJXJe2zmsX04JyJsjA=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  env.RUSTFLAGS = "--cfg tracing_unstable";

  meta = {
    description = "User-friendly, lightweight TUI for disk imaging";
    homepage = "https://github.com/ifd3f/caligula/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ifd3f
      sodiboo
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "caligula";
  };
})
