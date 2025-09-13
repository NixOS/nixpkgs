{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clippy,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fuc";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    tag = finalAttrs.version;
    hash = "sha256-fDSAqsKEx+th4tiJ3VlROqF4hhHzusqiw9enAmnOPlQ=";
  };

  cargoHash = "sha256-OoTWGeF96BpPDx1Y9AEVOIBK7kCz6pjw24pLiNcKmOc=";

  RUSTC_BOOTSTRAP = 1;

  cargoBuildFlags = [
    "--workspace"
    "--bin cpz"
    "--bin rmz"
  ];

  nativeCheckInputs = [
    clippy
    rustfmt
  ];

  # error[E0602]: unknown lint: `clippy::unnecessary_debug_formatting`
  doCheck = false;

  meta = {
    description = "Modern, performance focused unix commands";
    homepage = "https://github.com/SUPERCILEX/fuc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
