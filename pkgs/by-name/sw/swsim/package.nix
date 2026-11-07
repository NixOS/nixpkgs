{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  cmake,
  swicc,
}:

stdenv.mkDerivation {
  pname = "swsim";
  version = "0-unstable-2026-05-02";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tomasz-lisowski";
    repo = "swsim";
    rev = "281da8c63398ece9a5126cad969674f4f413ab63";
    hash = "sha256-cfbd9YV3odbXZ1TsbgHaYEiCmFan86fdSGoKAe4HbGI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc
    cmake
    swicc
  ];

  configurePhase = ''
    make main-dbg
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v ./build/swsim.elf $out/bin/swsim
  '';

  meta = {
    description = "Software SIM card";
    homepage = "https://github.com/tomasz-lisowski/swsim";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "swsim";
  };
}
