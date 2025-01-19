{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  guile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-sjson";
  version = "0.2.2";

  src = fetchFromGitLab {
    owner = "dustyweb";
    repo = "guile-sjson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MmnEZhJTbZDIO8vWVCoTt4rGbOjfPZQ3bqAGv4ei69o=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
  ];

  buildInputs = [
    guile
  ];

  meta = {
    description = "S-expression based json reader/writer for Guile";
    homepage = "https://gitlab.com/dustyweb/guile-sjson";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ galaxy ];
    platforms = guile.meta.platforms;
  };
})
