{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v9ycluLfkrPDzjsMXtv7w9UHgMaGzTsJw4lT/KfRAu4=";
  };

  cargoHash = "sha256-wVQEa1qS+JF6PHKvRrRFbSvj2qp6j14ErOQPkxP0uuA=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
