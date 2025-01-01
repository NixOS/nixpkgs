{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  elfutils,
  zlib,
  libbpf,
  clangStdenv,
}:
let
  pname = "bpftop";
  version = "0.5.2";
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "refs/tags/v${version}";
    hash = "sha256-WH/oCnkBcvoouBbkAcyawfAuNR3VsTl5+ZATLpi9d4w=";
  };

  cargoHash = "sha256-H9HapuIyJJOSQIR9IvFZaQ+Nz9M0MH12JwbY8r2l+JY=";

  buildInputs = [
    elfutils
    libbpf
    zlib
  ];

  nativeBuildInputs = [ pkg-config ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  meta = {
    description = "Dynamic real-time view of running eBPF programs";
    homepage = "https://github.com/Netflix/bpftop";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _0x4A6F
      luftmensch-luftmensch
      mfrw
    ];
    mainProgram = "bpftop";
  };
}
