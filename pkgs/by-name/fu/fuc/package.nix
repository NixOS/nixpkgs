{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clippy,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fuc";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    tag = finalAttrs.version;
    hash = "sha256-wmCLJUuGL5u0VIIT17VB63xjfyBVy7/f0Qy27MezDN8=";
  };

  cargoHash = "sha256-hZEPH0Bx7lCU9xYIFLqBez4y+gIA0+WCqag3ZE6cPM0=";

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
