{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  pkg-config,
  mpv-unwrapped,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "ostui";
  version = "1.0.4";

  src = fetchFromSourcehut {
    owner = "~ser";
    repo = "ostui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-efX19jkJnXyO4iuY2EZqhtLJZ7R/Q2JQZf72gyLgY8k=";
  };

  vendorHash = "sha256-Vmjd0bbeR9+PZCjh1cczE5MWeH5PDVE6obJLmV0wCLQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    mpv-unwrapped
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  env = {
    CGO_ENABLED = "1";
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://git.sr.ht/~ser/ostui";
    description = "Terminal client for *sonic music servers, inspired by ncmpcpp and musickube";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "ostui";
    maintainers = with lib.maintainers; [ m0streng0 ];
  };
})
