{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${version}";
    hash = "sha256-y2zrXS56fSsPaVmJcUxTMYhOroYjcNKepuI9tmdORsY=";
  };

  cargoHash = "sha256-Oom7CC8WBHd3hEQ62hQU91YbC4ydtdQuhAH6LFRN+P8=";

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
