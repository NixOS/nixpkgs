{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pgfmt";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "pgfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JNlIrE+ppT6Vk/t0cy/7Nm+G4s6mHl32QeksR3Ec6CQ=";
  };

  cargoHash = "sha256-DQH54QOd0BS4uIYA70yV0BNEY3SHyc18qqKr1Jbebe8=";

  meta = {
    description = "PostgreSQL SQL formatter";
    homepage = "https://github.com/gmr/pgfmt";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.amaidurova ];
    mainProgram = "pgfmt";
  };
})
