{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${version}";
    hash = "sha256-lWd8y/gZTLza9WrIBSsqg0TUkmwzvcZE97kj+NnHrSI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BuQNJTvL7vxAAS86ENTqgFbneaRo/W+C1rhTmF9BgUM=";

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
