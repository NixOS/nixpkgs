{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dcfldd";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "dcfldd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xn1+8hLiLQMOv0q0Jkuqha9EZSJWMbCksnq/G6n4vQ8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Enhanced version of GNU dd";

    homepage = "https://github.com/resurrecting-open-source-projects/dcfldd";

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ qknight ];
    mainProgram = "dcfldd";
  };
})
