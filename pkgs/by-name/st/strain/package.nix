{
  lib,
  fetchFromGitHub,
  rustPlatform,
  gmp,
  mpfr,
  libmpc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "strain";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "JacoMalan1";
    repo = "strain";
    tag = "${finalAttrs.version}";
    hash = "sha256-fZGCR8OODedgH3upUsqtNVuvMnoPhehS/vUmu1vMdzM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lbjPJzsNZSna5fcO6Vgf0+z3V6kPcNZqOgFFBfMFzpU=";

  buildInputs = [
    gmp
    mpfr
    libmpc
  ];

  meta = {
    description = "Lightweight CPU stress-testing utility written in Rust";
    homepage = "https://github.com/JacoMalan1/strain";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      JacoMalan1
    ];
    mainProgram = "strain";
  };
})
