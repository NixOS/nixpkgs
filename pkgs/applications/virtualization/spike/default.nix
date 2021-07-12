{ lib, stdenv, fetchgit, dtc, nixosTests, fetchpatch }:

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

  patches = [
    # Add missing headers to fix build.
    (fetchpatch {
      url = "https://github.com/riscv/riscv-isa-sim/commit/b3855682c2d744c613d2ffd6b53e3f021ecea4f3.patch";
      sha256 = "1v1mpp4iddf5n4h3kmj65g075m7xc31bxww7gldnmgl607ma7cnl";
    })
  ];

  postPatch = ''
    patchShebangs scripts/*.sh
    patchShebangs tests/ebreak.py
  '';

  doCheck = true;

  passthru.tests = {
    can-run-hello-world = nixosTests.spike;
  };

  meta = with lib; {
    description = "A RISC-V ISA Simulator";
    homepage = "https://github.com/riscv/riscv-isa-sim";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ blitz ];
  };
}
