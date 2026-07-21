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
  version = "1.3.4";

  src = fetchFromSourcehut {
    owner = "~ser";
    repo = "ostui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+8YZiFV86SuTYQT+FTMo55dQy/W35hD+mcJp8MUz17s=";
  };

  vendorHash = "sha256-cCyOG6nqlw2DPbA1dCuki5cpDy9LmZV/3YGyB3nCreI=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ mpv-unwrapped ];

  postConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace vendor/github.com/gen2brain/go-mpv/purego_linux.go \
      --replace-warn '"libmpv.so"' '"${lib.getLib mpv-unwrapped}/lib/libmpv.so"' \
      --replace-warn '"libmpv.so.2"' '"${lib.getLib mpv-unwrapped}/lib/libmpv.so.2"'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  env.CGO_ENABLED = if stdenv.hostPlatform.isLinux then "0" else "1";

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
