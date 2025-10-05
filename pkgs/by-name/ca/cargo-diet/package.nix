{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-diet";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = "cargo-diet";
    rev = "v${version}";
    hash = "sha256-SuJ1H/2YfSVVigdgLUd9veMClI7ZT7xkkyQ4PfXoQdQ=";
  };

  cargoHash = "sha256-crdRRlRi3H8j/ojGH+oqmaeSS8ee8dUALorZPWE/j1Y=";

  meta = {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    mainProgram = "cargo-diet";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
