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
  version = "0.5.1";
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    rev = "refs/tags/v${version}";
    hash = "sha256-CSQfg0JuWm0CFyC4eXxn7eSyKIu0gKAqgiQT64tgnDI=";
  };

  cargoHash = "sha256-Hg763Zy5KRZqEDoasoDScZGAPb1ABRp+LI1c7IYJNf0=";

  buildInputs = [
    elfutils
    libbpf
    zlib
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "A dynamic real-time view of running eBPF programs";
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
