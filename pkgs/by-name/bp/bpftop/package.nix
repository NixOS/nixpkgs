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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "v${version}";
    hash = "sha256-1Wgfe+M1s3hxcN9g1KiBeZycdgpMiHy5FWlE0jlNq/U=";
  };

  cargoHash = "sha256-CrAH3B3dCg3GsxvRrVp/jx3YSpmEg4/jyNuXUO/zeq0=";

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
