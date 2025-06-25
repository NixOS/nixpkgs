{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clippy,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fuc";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    tag = finalAttrs.version;
    hash = "sha256-VHIR/hw++Zv1IWzx45B7PTK0Jyzt1QqzM+Bj6CBAh1A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xYpxrg8RWDW3RBvHRafrSh7gEB6qGGGxl/QRM1rtZJY=";

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
