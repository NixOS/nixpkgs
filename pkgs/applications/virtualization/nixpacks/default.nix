{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "v0.1.7";
  cargoSha256 = "iA8ODh1NmUBfyH6syvVD32jDeLYG2LeLTo2lQoO93lc=";
  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = version;
    sha256 = "UxdK2e5VYcOEYdZn0oGRFIVGiwnPixiZ3rOnqJDSQO8=";
  };
  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
