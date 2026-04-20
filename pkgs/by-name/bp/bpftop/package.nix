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
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "bpftop";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2W00L4JudB7D3IBpY9But+I5erU5+Hf/M2h3jERYObc=";
  };

  cargoHash = "sha256-5VzItvqcBzXGAMEY6ZgvJSDkA+fF7ega4NSEaskhL5w=";

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
})
