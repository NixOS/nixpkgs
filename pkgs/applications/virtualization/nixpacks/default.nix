{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UxdK2e5VYcOEYdZn0oGRFIVGiwnPixiZ3rOnqJDSQO8=";
  };

  cargoSha256 = "sha256-dJdPs4BJ1R2ZbGmGmvBerLPVqUHn5b/fz9C0kEnxA6U=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
