{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DRYAVwNrNnMB5e1HQz3gmKcM9O7qWquGVsvWQHkCdhw=";
  };

  cargoSha256 = "sha256-+T8bnUeuzHcHEADZyxvjVuRlEoqMm8T2L9L5hqhNJKU=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
