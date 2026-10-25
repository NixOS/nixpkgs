{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  clp,
  coin-utils,
  osi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgl";
  version = "0.60.10";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Cgl";
    rev = "releases/${finalAttrs.version}";
    hash = "sha256-zkq8pdn4m56sGd3I6xID3M+u7BxVp0S5naKBjqAdeyE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    clp
    coin-utils
    osi
  ];

  meta = {
    description = "Cut Generator Library";
    homepage = "https://github.com/coin-or/Cgl";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})
