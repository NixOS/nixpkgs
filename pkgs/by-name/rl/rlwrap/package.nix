{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rlwrap";
  version = "0.46.2";

  src = fetchFromGitHub {
    owner = "hanslub42";
    repo = "rlwrap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-05q24Y097GCcipXEPTbel/YIAtQl4jDyA9JFjDDM41Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  buildInputs = [ readline ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=implicit-function-declaration";

  meta = with lib; {
    description = "Readline wrapper for console programs";
    homepage = "https://github.com/hanslub42/rlwrap";
    changelog = "https://github.com/hanslub42/rlwrap/raw/refs/tags/v${finalAttrs.version}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jlesquembre ];
    mainProgram = "rlwrap";
  };
})
