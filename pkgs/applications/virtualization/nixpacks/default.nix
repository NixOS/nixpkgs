{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uxy0/Ngzzh96YZDR9whLVYNnQOlj3wkCEuuJTQjT6GE=";
  };

  cargoSha256 = "sha256-99J4ucjE0yTPQSdM6PDTWEjBltJdIU6yEDqhgSfOaJU=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
