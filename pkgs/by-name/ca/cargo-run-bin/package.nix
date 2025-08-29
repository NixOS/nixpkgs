{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.7.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-79DJ6j2sai1dTdcXf0qD97TCNZuGRSUobLGahoApMss=";
  };

  cargoHash = "sha256-UTdJQ/lnsYa85/xXkmgI/ByzKu3+DB3riQKGCVjF3to=";

  # multiple impurities in tests
  doCheck = false;

  meta = {
    description = "Build, cache, and run binaries scoped in Cargo.toml rather than installing globally. This acts similarly to npm run and gomodrun, and allows your teams to always be running the same tooling versions";
    mainProgram = "cargo-bin";
    homepage = "https://github.com/dustinblackman/cargo-run-bin";
    changelog = "https://github.com/dustinblackman/cargo-run-bin/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mightyiam
      matthiasbeyer
    ];
  };
}
