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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "v${version}";
    hash = "sha256-zYCv3L+xDFAJ4Wo9xwfHJrqPQUv5KiFDbhCdC1Z6qNo=";
  };

  cargoHash = "sha256-6uPfMxjSrSGrAgJcvzTY/i1ckoW/wIi7D5noOafCvZE=";

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
