{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin, git }:

rustPlatform.buildRustPackage rec {
  pname = "git-nomad";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rraval";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1PXAdXafkPOIVzaWjW/RlWHwYhMqPoj0Hj5JmOMUj8A=";
  };

  cargoHash = "sha256-ULcdJRla1JwI0y6ngW9xQXjNw2wO48HuAczsNIsJJK0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  checkInputs = [
    git
  ];

  meta = with lib; {
    description = "Synchronize work-in-progress git branches in a light weight fashion";
    homepage = "https://github.com/rraval/git-nomad";
    changelog = "https://github.com/rraval/git-nomad/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rraval ];
  };
}
