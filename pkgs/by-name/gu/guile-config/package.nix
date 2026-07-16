{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  texinfo,
  guile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-config";
  version = "0.5.1";

  src = fetchFromGitLab {
    owner = "a-sassmannshausen";
    repo = "guile-config";
    rev = finalAttrs.version;
    hash = "sha256-n4ukGCyIx5G1ITfKSqS6FGJ6dnDBsyxXKSFNi81E4Gg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Configuration management library for GNU Guile";
    homepage = "https://gitlab.com/a-sassmannshausen/guile-config";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = guile.meta.platforms;
  };
})
