{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clippy,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fuc";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    tag = finalAttrs.version;
    hash = "sha256-jn553QosWi7avgSjT72lL8auVVd/n4+5MDCJAquflgs=";
  };

  cargoHash = "sha256-kxaB3R9V8JG2EdLfGFrP12wt9TZco7QfpfNbLQZDq30=";

  env.RUSTC_BOOTSTRAP = 1;

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
    maintainers = [ ];
  };
})
