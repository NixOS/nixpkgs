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
  version = "1.3.3";

  src = fetchFromSourcehut {
    owner = "~ser";
    repo = "ostui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zm7j4s+GLILLnH+CjF8JsJB4APYeWV7TyCUkKLW2SGQ=";
  };

  vendorHash = "sha256-yhoTwouYlv2VkCWmvwvvpbQmrFwzwpraf0EV2Tegq94=";

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
