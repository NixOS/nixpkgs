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

  cargoHash = "sha256-MASftcn3WmB3M6bvmtnK3nlroE8nq9zdkleSEgzA5lk=";

  meta = with lib; {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    mainProgram = "cargo-diet";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
