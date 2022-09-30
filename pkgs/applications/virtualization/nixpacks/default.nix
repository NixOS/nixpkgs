{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5ImGG3sovDFya1o6bbEu3JaS3xUaO9gfAnw28GZf2aU=";
  };

  cargoSha256 = "sha256-WAnFucDCG0h+tfy6wHyWjIU7HpJ4Qylxw2Q4sgZgp7I=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
