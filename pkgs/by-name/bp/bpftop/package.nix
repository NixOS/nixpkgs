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
    tag = "v${version}";
    hash = "sha256-WH/oCnkBcvoouBbkAcyawfAuNR3VsTl5+ZATLpi9d4w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fXNu0u+YdT5UaKReT4WuQINKz/zFnwXS1r+xEH6g9FU=";

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
