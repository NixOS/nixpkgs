{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z1xmBoRdOTMB9NHGWKQyweT0/PyjGHiK+yj5uKjZPtE=";
  };

  cargoSha256 = "sha256-jLO1UPfu0vN2NCvvGBnUY1UPV1F+0fYlrtsM/AE39tU=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
