{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caligula";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0KSQd/DvIo813HSLL+Qvn+5GMFRK7CGxOSq4+Fyl8Zk=";
  };

  cargoHash = "sha256-ICvQ7XtA7705gJ0GijuZJROGAp/BMpyqsIygR+6kJ2I=";

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
