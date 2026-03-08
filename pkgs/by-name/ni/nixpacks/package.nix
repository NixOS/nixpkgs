{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpacks";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "nixpacks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y2zrXS56fSsPaVmJcUxTMYhOroYjcNKepuI9tmdORsY=";
  };

  cargoHash = "sha256-Oom7CC8WBHd3hEQ62hQU91YbC4ydtdQuhAH6LFRN+P8=";

  # skip test due FHS dependency
  doCheck = false;

  meta = {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zoedsoupe ];
    mainProgram = "nixpacks";
  };
})
