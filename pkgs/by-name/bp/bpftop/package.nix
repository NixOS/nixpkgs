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
  version = "0.6.0";
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    tag = "v${version}";
    hash = "sha256-oilSWF3dCbJIPtkxwj76qReh5Rp8ZRiH2nVriK6d3fk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k5cRj66OSXsCXUPWrBYrOFq8aohaB/afd8IGj0QqvuE=";

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
