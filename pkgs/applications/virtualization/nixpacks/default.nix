{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0Q0G2vUIkKRTSbQQrXoInzaPfFNWwT/NQ1/NKQeVpHU=";
  };

  cargoSha256 = "sha256-vLUR8Rs33GukkRihoB9jD3G4ailJc8oakm7NSjoZdok=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
