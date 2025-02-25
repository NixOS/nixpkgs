{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (attrs: {
  pname = "air-formatter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "air";
    rev = attrs.version;
    hash = "sha256-BUbOG4D5UD+Z8Cpr4qodUrM3FFcMwjBd4M/YdPZPtpM=";
  };

  # Remove duplicate entries from cargo lock
  cargoPatches = [ ./cargo-lock.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-EnvhqAZK76O6g99OgLruQDBUe9m9bn5ier3bgHI/f+A=";

  useNextest = true;

  meta = {
    description = "An extremely fast R code formatter";
    homepage = "https://posit-dev.github.io/air";
    changelog = "https://github.com/posit-dev/air/blob/" + attrs.version + "/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
    mainProgram = "air";
  };
})
