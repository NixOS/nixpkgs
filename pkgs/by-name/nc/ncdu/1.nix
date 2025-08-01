{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "1.22";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-CtbAltwE1RIFgRBHYMAbj06X1BkdbJ73llT6PGkaF2s=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "ncdu";
  };
})
