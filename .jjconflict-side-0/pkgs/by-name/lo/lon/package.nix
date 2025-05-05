{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lon";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "lon";
    tag = version;
    hash = "sha256-LtZhEfdO/kTbeDG/lhiH+9QPw3kgov72Xn1NelgNsE0=";
  };

  sourceRoot = "source/rust/lon";

  useFetchCargoVendor = true;
  cargoHash = "sha256-cr1+WBlq/uuOVDIbgN5UhsQ0ISLDYOxyGRnQ6ntEH5w=";

  meta = {
    description = "Lock & update Nix dependencies";
    homepage = "https://github.com/nikstur/lon";
    changelog = "https://github.com/nikstur/lon/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      ma27
      nikstur
    ];
    license = lib.licenses.mit;
    mainProgram = "lon";
  };
}
