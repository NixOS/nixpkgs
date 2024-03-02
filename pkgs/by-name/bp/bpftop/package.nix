{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, elfutils
, zlib
, libbpf
}:

rustPlatform.buildRustPackage rec {
  pname = "bpftop";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "v${version}";
    hash = "sha256-mtif1VRlDL1LsJQ3NQmBEaHTxrt2qMbZAFCEhtm/CtI=";
  };

  cargoHash = "sha256-N3pmet7OkIaI3EnzHfqe5P24RHabNUArEB1cKUYM5rA=";

  buildInputs = [
    elfutils
    libbpf
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "A dynamic real-time view of running eBPF programs";
    homepage = "https://github.com/Netflix/bpftop";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _0x4A6F
      mfrw
    ];
    mainProgram = "bpftop";
  };
}
