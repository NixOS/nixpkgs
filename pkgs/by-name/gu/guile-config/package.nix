{
  lib,
  autoreconfHook,
  fetchFromGitLab,
  guile,
  pkg-config,
  stdenv,
  texinfo,
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

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  enableParallelBuilding = true;

  doCheck = true;

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.com/a-sassmannshausen/guile-config";
    description = "Configuration management library for GNU Guile";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    inherit (guile.meta) platforms;
  };
})
