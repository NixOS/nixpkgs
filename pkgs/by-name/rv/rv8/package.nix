{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "rv8";
  version = "0-unstable-2018-09-22";

  src = fetchFromGitHub {
    owner = "michaeljclark";
    repo = "rv8";
    rev = "834259098a5c182874aac97d82a164d144244e1a";
    hash = "sha256-I1lMKxfu+04Ap9WNjr8S1FLcUpQ3pVlTu61L/LFFGJ0=";
    fetchSubmodules = true;
  };

  patches = [
    # src/gen/gen-{cc,fpu-test}.cc fail to build because they mention
    # std::numeric_limits without first including the <limits> header
    ./rv8-include-limits.patch
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
    "DEST_DIR=$(out)"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/{bin,lib}
  '';

  meta = {
    description = "RISC-V simulator for x86-64";
    longDescription = ''
      rv8 is a RISC-V simulation suite comprising a high performance x86-64 binary
      translator, a user mode simulator, a full system emulator, an ELF binary
      analysis tool and ISA metadata.
    '';

    homepage = "https://michaeljclark.github.io/";
    license = lib.licenses.mit;
    platforms = lib.platforms.x86_64;
    maintainers = with lib.maintainers; [ _3442 ];
  };
}
