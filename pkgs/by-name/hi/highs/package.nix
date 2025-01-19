{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highs";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VUbYg1NRoRk0IzO6y+NaWnfjOuIYoM8pfPPqJcG7Bbo=";
  };

  strictDeps = true;

  outputs = [ "out" ];

  doInstallCheck = true;

  installCheckPhase = ''
    "$out/bin/highs" --version
  '';

  nativeBuildInputs = [
    clang
    cmake
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/ERGO-Code/HiGHS";
    description = "Linear optimization software";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "highs";
    maintainers = with lib.maintainers; [ silky ];
  };
})
