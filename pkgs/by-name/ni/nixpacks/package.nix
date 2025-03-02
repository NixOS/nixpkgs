{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${version}";
    hash = "sha256-YI/4hr1910ScL3HvjiijRmFq4P3xMxn3el1xPd7i53o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WQqGKkOSmbAcVoVVxL9YdNl9DnirNKGsg5d+s9uwTWc=";

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
