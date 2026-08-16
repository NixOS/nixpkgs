{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clippy,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fuc";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    tag = finalAttrs.version;
    hash = "sha256-EzT8Rq0vqcHiW6W0yLSzlWNEZzaKXvOL3o9WUj648gU=";
  };

  cargoHash = "sha256-sZGAQ+9u/2PpHkp5BcrrTU+48s6PT42+eEs/Cn0RsKk=";

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
