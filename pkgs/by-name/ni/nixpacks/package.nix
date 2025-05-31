{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${version}";
    hash = "sha256-1Kw5vOE8UhGWlSjBX/wMiUyRvCYwha343RiGAXEcFXw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rmndlNqUtGpSBLclyoTL01CP3qgCNoTmOnpR+9ux/VE=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
    mainProgram = "nixpacks";
  };
}
