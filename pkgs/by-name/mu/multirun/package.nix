{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multirun";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "nicolas-van";
    repo = "multirun";
    rev = finalAttrs.version;
    hash = "sha256-I95nxZD65tHiok4MzsGG7gyaxPHbqQLuRWdHUPNhLu8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Minimalist init process designed for Docker";
    homepage = "https://github.com/nicolas-van/multirun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "multirun";
    platforms = lib.platforms.all;
  };
})
