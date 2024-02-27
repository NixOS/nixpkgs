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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "v${version}";
    hash = "sha256-HP8ubzCfBNgISrAyLACylH4PHxLhJPzIQFmIWEL5gjo=";
  };

  cargoHash = "sha256-+zh7GZ/fbhxLNQkkHFZqtJxy2IeS+KX5s2Qi5N21u/0=";

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
    maintainers = with lib.maintainers; [ mfrw ];
    mainProgram = "bpftop";
  };
}
