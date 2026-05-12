{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caligula";
  version = "0.5.0-rc.2";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6f5g+KXvaVWr0BAxvYJ1oCxWPLa/32zOIcPvirYntKA=";
  };

  cargoHash = "sha256-vfh0PKioBG7ZP8S+VLbp5iyl282rAxo/dj0VRgFgyN0=";

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
