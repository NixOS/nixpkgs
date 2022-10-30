{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QLF49k8f8YYwPl26pyz9/bbO4IO0KqSlgTFNjbvPf7k=";
  };

  cargoSha256 = "sha256-u0L3NJ4ku5ETBx6PKgVStrcSCX4I7E6GNtW+iv3yy2g=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
