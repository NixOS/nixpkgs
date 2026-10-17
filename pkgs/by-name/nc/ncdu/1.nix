{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "BratishkaErik";
    repo = "ncdu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XhBZlcQ7QmzdmNjHa0saWZUkqbGPD041Y2IW13Y3R40=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [ ncurses ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://github.com/BratishkaErik/ncdu";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "ncdu";
  };
})
