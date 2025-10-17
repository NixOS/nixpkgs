{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
  libptytty,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rlwrap";
  version = "0.47.1";

  src = fetchFromGitHub {
    owner = "hanslub42";
    repo = "rlwrap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jkzvGfqrL4v8SK8Mi1SgKDYibnFfNU1xAlJJ8ZMKFfY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  buildInputs = [
    libptytty
    readline
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=implicit-function-declaration";

  preBuild = ''
    touch src/completion.rb
    touch src/completion.c
  '';

  meta = {
    description = "Readline wrapper for console programs";
    homepage = "https://github.com/hanslub42/rlwrap";
    changelog = "https://github.com/hanslub42/rlwrap/raw/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jlesquembre ];
    mainProgram = "rlwrap";
  };
})
