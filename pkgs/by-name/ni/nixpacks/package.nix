{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.39.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${version}";
    hash = "sha256-FHpAZizgqizVhIwmMPbddpC7iOYpq0RGLoysWfKvJhc=";
  };

  cargoHash = "sha256-ecT+/EMKZjI89aEW1w9Qjdc8srkVIYgmCtjwI55BI1I=";

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
