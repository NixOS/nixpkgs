{ lib, stdenv, fetchFromGitHub, dtc, pkgsCross }:

stdenv.mkDerivation rec {
  pname = "spike";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-isa-sim";
    rev = "v${version}";
    sha256 = "sha256-4D2Fezej0ioOOupw3kgMT5VLs+/jXQjwvek6v0AVMzI=";
  };

  nativeBuildInputs = [ dtc ];
  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs scripts/*.sh
    patchShebangs tests/ebreak.py
  '';

  doCheck = true;

  # To test whether spike is working, we run the RISC-V hello applications using the RISC-V proxy
  # kernel on the Spike emulator and see whether we get the expected output.
  doInstallCheck = true;
  installCheckPhase =
    let
      riscvPkgs = pkgsCross.riscv64-embedded;
    in
    ''
      runHook preInstallCheck

      echo -e "#include<stdio.h>\nint main() {printf(\"Hello, world\");return 0;}" > hello.c
      ${riscvPkgs.stdenv.cc}/bin/${riscvPkgs.stdenv.cc.targetPrefix}cc -o hello hello.c
      $out/bin/spike -m64 ${riscvPkgs.riscv-pk}/bin/pk hello | grep -Fq "Hello, world"

      runHook postInstallCheck
    '';

  meta = with lib; {
    description = "A RISC-V ISA Simulator";
    homepage = "https://github.com/riscv/riscv-isa-sim";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ blitz ];
  };
}
