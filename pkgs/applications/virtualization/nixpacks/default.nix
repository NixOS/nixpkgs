{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wzbyBofWYXkOx+kNAmo9lDQdfkYLndh+Pw09+bxNqbU=";
  };

  cargoSha256 = "sha256-0KMs4YeWMj4Wz+iIVQ5XEwswVRs0q5Vibcy5fFNbH04=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
