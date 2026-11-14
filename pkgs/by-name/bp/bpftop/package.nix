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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "jfernandez";
    repo = "bpftop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nflwQhUIOD5GNWvFKt9aU6j9xkKhtzub5IsDGQvZkTo=";
  };

  cargoHash = "sha256-kh/ZS1P2o7AGPkjFpqyJCeLj91H13SNPFcTBOFHvoZ8=";

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
    homepage = "https://github.com/jfernandez/bpftop";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _0x4A6F
      luftmensch-luftmensch
      mfrw
    ];
    mainProgram = "bpftop";
  };
})
