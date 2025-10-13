{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "finalcut";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "gansm";
    repo = "finalcut";
    tag = finalAttrs.version;
    hash = "sha256-iKLE4UMDbnsKYEjQHlF+xyZSBke1EZSVJiabbKRkzhg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [ ncurses ];

  meta = {
    description = "Text-based widget toolkit";
    homepage = "https://github.com/gansm/finalcut";
    changelog = "https://github.com/gansm/finalcut/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
