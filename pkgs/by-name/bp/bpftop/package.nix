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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "bpftop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QukcBq80tASPSHRg1yRouYiZqvca+ipp6RGzXqP2CwA=";
  };

  cargoHash = "sha256-33VamoVq8O4cgdweWRaDqo5ey2lbLAHoPQVPgmyQwh0=";

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
