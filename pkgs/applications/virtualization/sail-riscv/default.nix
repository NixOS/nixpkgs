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
  version = "0.6";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = pname;
    rev = version;
    hash = "sha256-cO0ZOr2frMMLE9NUGDxy9+KpuyBnixw6wcNzUArxDiE=";
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

  postPatch = ''
    rm -r prover_snapshots
  '';

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
