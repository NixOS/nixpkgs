{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caligula";
  version = "0.5.0-rc.1";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZCnTn0s6bWczKlJZ2GtbkjJHpPiR98G3c5pjlpUvI38=";
  };

  cargoHash = "sha256-I3qMrU7iwOAR6xUE2uhi3ToeEoh3+UY93dxTFdgyH3k=";

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
