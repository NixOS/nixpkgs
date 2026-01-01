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
  version = "0.60.9";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Cgl";
    rev = "releases/${finalAttrs.version}";
    hash = "sha256-E84yCrgpRMjt7owPLPk1ATW+aeHNw8V24DHgkb6boIE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    clp
    coin-utils
    osi
  ];

<<<<<<< HEAD
  meta = {
    description = "Cut Generator Library";
    homepage = "https://github.com/coin-or/Cgl";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Cut Generator Library";
    homepage = "https://github.com/coin-or/Cgl";
    license = licenses.epl20;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
