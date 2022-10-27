{ lib, stdenv, rustPlatform, fetchFromGitHub, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "git-nomad";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rraval";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1PXAdXafkPOIVzaWjW/RlWHwYhMqPoj0Hj5JmOMUj8A=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  cargoHash = "sha256-ULcdJRla1JwI0y6ngW9xQXjNw2wO48HuAczsNIsJJK0=";

  meta = with lib; {
    description = "Synchronize work-in-progress git branches in a light weight fashion";
    homepage = "https://github.com/rraval/git-nomad";
    license = licenses.mit;
    maintainers = with maintainers; [ rraval ];
  };
}
