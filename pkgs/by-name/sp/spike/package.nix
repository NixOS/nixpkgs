{
  lib,
  stdenv,
  fetchFromGitHub,
  dtc,
  pkgsCross,
}:

stdenv.mkDerivation {
  pname = "spike";
  version = "1.1.0-unstable-2026-10-20";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "riscv-isa-sim";
    rev = "d140cbc0ae4ef4fc64ad323f3f175ff15f6dca56";
    sha256 = "sha256-chyTl7v7pZUGcRczzrawLOYxSYbbk7eWohcbduU7VBU=";
    # Pulls in ucb-bar/berkeley-softfloat-3
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ dtc ];
  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs scripts/*.sh
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

  meta = {
    description = "RISC-V ISA Simulator";
    homepage = "https://github.com/riscv-software-src/riscv-isa-sim";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      blitz
      evanwporter
    ];
  };
}
