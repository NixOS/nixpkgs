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
  version = "0.7.1";
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    tag = "v${version}";
    hash = "sha256-8vb32+wHOnADpIIfO9mMlGu7GdlA0hS9ij0zSLcrO7A=";
  };

  cargoHash = "sha256-euiI4R4nCgnwiBA22kzn0c91hjOr0IOOAyFkW5ZadIk=";

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
