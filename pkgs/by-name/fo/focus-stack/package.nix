{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  ronn,
  opencv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "focus-stack";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "PetteriAimonen";
    repo = "focus-stack";
    rev = finalAttrs.version;
    hash = "sha256-hIaK8hjeuu6w/8nh9DHOffqZufQdqB1/VQRezCPQIPk=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    ronn
  ];
  buildInputs = [ opencv ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Fast and easy focus stacking";
    homepage = "https://github.com/PetteriAimonen/focus-stack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "focus-stack";
  };
})
