{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
}:
stdenv.mkDerivation {
  pname = "guile-syntax-highlight";
  version = "unstable-2025-10-13";

  src = fetchgit {
    url = "https://git.dthompson.us/guile-syntax-highlight.git";
    rev = "ce45e68b20d0e64d546f22d066f8ffe537e474f4";
    hash = "sha256-bJyoR/9CrLay38abhXSWmMMACpxUoCQvpulv7/nFmeU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    guile
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  meta = {
    homepage = "https://dthompson.us/projects/guile-syntax-highlight.html";
    description = "General purpose syntax highlighting for Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ abbe ];
    platforms = guile.meta.platforms;
  };
}
