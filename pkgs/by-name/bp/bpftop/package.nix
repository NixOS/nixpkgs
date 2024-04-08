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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "v${version}";
    hash = "sha256-OLPebPzb2FKiV1Gc8HTK3sXU2UDMyhFA/XLix/lWxgU=";
  };

  cargoHash = "sha256-UYCbNECsos71cwwE5avtaijPaPGhLEU7J9i84wPkObI=";

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
