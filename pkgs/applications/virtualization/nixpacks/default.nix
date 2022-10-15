{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7lr4Ym8E3o8dWyy1GlBQfhLGWoR6uzjiWTWmuSGXmMM=";
  };

  cargoSha256 = "sha256-v2OC69YpVbJ52z9iO98kfzC3A4fpotcGBhpwESjdvU4=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
