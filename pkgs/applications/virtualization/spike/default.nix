{ stdenv, fetchgit, dtc, nixosTests }:

stdenv.mkDerivation rec {
  pname = "spike";
  version = "1.0.0";

  src = fetchgit {
    url = "https://github.com/riscv/riscv-isa-sim.git";
    rev = "v${version}";
    sha256 = "1hcl01nj96s3rkz4mrq747s5lkw81lgdjdimb8b1b9h8qnida7ww";
  };

  nativeBuildInputs = [ dtc ];
  enableParallelBuilding = true;

  patchPhase = ''
    patchShebangs scripts/*.sh
    patchShebangs tests/ebreak.py
  '';

  doCheck = true;

  passthru.tests = {
    can-run-hello-world = nixosTests.spike;
  };

  meta = with stdenv.lib; {
    description = "A RISC-V ISA Simulator";
    homepage = "https://github.com/riscv/riscv-isa-sim";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ blitz ];
  };
}
