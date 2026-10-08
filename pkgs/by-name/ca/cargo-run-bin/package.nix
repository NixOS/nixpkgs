{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-run-bin";
  version = "1.7.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-XZaXAEI53u5kPLzY5uPQmNz1b5Z00YbbrjK/Uy9AV5I=";
  };

  cargoHash = "sha256-CuqVj098w5q+xx0O9bZs76PTNjuj+02mh3BxOu98Ldg=";

  # multiple impurities in tests
  doCheck = false;

  meta = {
    description = "Build, cache, and run binaries scoped in Cargo.toml rather than installing globally. This acts similarly to npm run and gomodrun, and allows your teams to always be running the same tooling versions";
    mainProgram = "cargo-bin";
    homepage = "https://github.com/dustinblackman/cargo-run-bin";
    changelog = "https://github.com/dustinblackman/cargo-run-bin/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
