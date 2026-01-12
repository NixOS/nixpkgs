{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  makeWrapper,
  stdenv,

  jansson,
  libidn2,
  libmilter,
  openssl,
  pkg-config,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openarc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "flowerysong";
    repo = "OpenARC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eEQ0iiAt/RCxHJPpEiZY1TNgjGJjg+kMsVWI7vNaWlc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    jansson
    libidn2
    libmilter
    openssl
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-DBIND_8_COMPAT";

  postInstall = ''
    wrapProgram $out/bin/openarc-keygen \
      --prefix PATH : ${
        lib.makeBinPath [
          openssl
          python3
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/flowerysong/OpenARC";
    description = "Open source library and filter for adding Authenticated Received Chain (ARC) support (RFC 8617) to email messages";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = with lib.licenses; [
      bsd2
      sendmail
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lucasbergman ];
    mainProgram = "openarc";
  };
})
