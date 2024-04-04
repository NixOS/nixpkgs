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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "v${version}";
    hash = "sha256-N5sszFVU1nMS6QQENa9JcgFKSSWs07bWn6usvV/QmX4=";
  };

  cargoHash = "sha256-yVNql4fSU1HhLKy8HYUbNnMnxgr/gPuqKol5O0ZDQlY=";

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
