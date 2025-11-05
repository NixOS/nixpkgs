{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "doctave";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "doctave";
    repo = "doctave";
    rev = version;
    hash = "sha256-8mGSFQozyLoGua9mwyqfDcYNMtbeWp9Phb0vaje+AJ0=";
  };

  cargoHash = "sha256-3gyYls1+5eVM3eLlFNmULvIbc5VgoWpfnpO4nmoDMAI=";

  meta = {
    description = "Batteries-included developer documentation site generator";
    homepage = "https://github.com/doctave/doctave";
    changelog = "https://github.com/doctave/doctave/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "doctave";
  };
}
