{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  texinfo,
  guile,
}:

stdenv.mkDerivation rec {
  pname = "guile-config";
  version = "0.5.1";

  src = fetchFromGitLab {
    owner = "a-sassmannshausen";
    repo = "guile-config";
    rev = version;
    hash = "sha256-n4ukGCyIx5G1ITfKSqS6FGJ6dnDBsyxXKSFNi81E4Gg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Configuration management library for GNU Guile";
    homepage = "https://gitlab.com/a-sassmannshausen/guile-config";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = guile.meta.platforms;
  };
}
