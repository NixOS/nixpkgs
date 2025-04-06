{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.34.1";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${version}";
    hash = "sha256-G3PIQfwddATVNhe/cEZBSFESX3grFqjUQjq40DB5mH4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h6DoUCj7wjN/qiy0rsC2fCHhQ8hcmSwFu7zaRw9tCUs=";

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
