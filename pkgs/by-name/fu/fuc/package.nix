{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clippy,
  rustfmt,
}:

rustPlatform.buildRustPackage rec {
  pname = "fuc";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    rev = version;
    hash = "sha256-ZEiMyX85woPOKaMtw8qqrUXUhY8Ewm71I25inUMH1GQ=";
  };

  cargoHash = "sha256-7xPZFZ+vWi6HbaHeIWEnOfQkHsLIMsHq+RuuDOWwusQ=";

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

  meta = with lib; {
    description = "Modern, performance focused unix commands";
    homepage = "https://github.com/SUPERCILEX/fuc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
