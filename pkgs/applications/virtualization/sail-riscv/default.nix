{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  gmp,
  pkg-config,
  sail,
  ninja,
  z3,
}:

stdenv.mkDerivation rec {
  pname = "sail-riscv";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "sail-riscv";
    rev = version;
    hash = "sha256-50ATe3DQcdyNOqP85mEMyEwxzpBOplzRN9ulaJNo9zo=";
  };

  nativeBuildInputs = [
    z3
    cmake
    pkg-config
    ninja
    sail
  ];
  buildInputs = [
    gmp
  ];
  strictDeps = true;

  # sail-riscv 0.8 fails to install without compressed_changelog
  ninjaFlags = [ "compressed_changelog" ];

  meta = with lib; {
    homepage = "https://github.com/riscv/sail-riscv";
    description = "Formal specification of the RISC-V architecture, written in Sail";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd2;
  };
}
