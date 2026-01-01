{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
<<<<<<< HEAD
  libptytty,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rlwrap";
<<<<<<< HEAD
  version = "0.48";
=======
  version = "0.46.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hanslub42";
    repo = "rlwrap";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Szgyjt/KRFEZMu6JX4Ulm2guTMwh9ejzjlfpkITWOI4=";
=======
    hash = "sha256-05q24Y097GCcipXEPTbel/YIAtQl4jDyA9JFjDDM41Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

<<<<<<< HEAD
  buildInputs = [
    libptytty
    readline
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=implicit-function-declaration";

  # no environment to compile completion.c, update its time to avoid recompiling
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
=======
  buildInputs = [ readline ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=implicit-function-declaration";

  meta = with lib; {
    description = "Readline wrapper for console programs";
    homepage = "https://github.com/hanslub42/rlwrap";
    changelog = "https://github.com/hanslub42/rlwrap/raw/refs/tags/v${finalAttrs.version}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jlesquembre ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rlwrap";
  };
})
