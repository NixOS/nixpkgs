{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  ronn,
  opencv,
}:

stdenv.mkDerivation rec {
  pname = "focus-stack";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "PetteriAimonen";
    repo = "focus-stack";
    rev = version;
    hash = "sha256-SoECgBMjWI+n7H6p3hf8J5E9UCLHGiiz5WAsEEioJsU=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    ronn
  ];
  buildInputs = [ opencv ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Fast and easy focus stacking";
    homepage = "https://github.com/PetteriAimonen/focus-stack";
    license = licenses.mit;
    maintainers = with maintainers; [ paperdigits ];
    mainProgram = "focus-stack";
  };
}
