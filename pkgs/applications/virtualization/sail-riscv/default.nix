{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  gmp,
  pkg-config,
  sail,
  ninja,
  zlib,
  z3,
}:

stdenv.mkDerivation rec {
  pname = "sail-riscv";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "sail-riscv";
    rev = version;
    hash = "sha256-Keu96+yHWUEFO3rRLvF7rzcJmF3y/V/uyK7TIFj0Xw0=";
  };

  nativeBuildInputs = [
    z3
    cmake
    pkg-config
    ninja
    sail
  ];
  buildInputs = [
    zlib
    gmp
  ];
  strictDeps = true;

  preBuild = ''
    ninja \
      riscv_sim_rv32d      \
      riscv_sim_rv32d_rvfi \
      riscv_sim_rv32f      \
      riscv_sim_rv32f_rvfi \
      riscv_sim_rv64d      \
      riscv_sim_rv64d_rvfi \
      riscv_sim_rv64f      \
      riscv_sim_rv64f_rvfi
  '';

  meta = with lib; {
    homepage = "https://github.com/riscv/sail-riscv";
    description = "Formal specification of the RISC-V architecture, written in Sail";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd2;
  };
}
