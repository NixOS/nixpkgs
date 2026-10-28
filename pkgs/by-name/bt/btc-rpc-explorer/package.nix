{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  python3,
  vips,
}:

buildNpmPackage rec {
  pname = "btc-rpc-explorer";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "janoside";
    repo = "btc-rpc-explorer";
    rev = "v${version}";
    hash = "sha256-L7mW1WIbHga6/UjMx4sP0MUhJIRytUhHVIEWMD2amQo=";
  };

  npmDepsHash = "sha256-eYA2joO4wcV10xJeYLqCbvM2szWlqofmugoHHD9D30U=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    vips
  ];

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/janoside/btc-rpc-explorer/blob/${src.rev}/CHANGELOG.md";
    description = "Database-free, self-hosted Bitcoin explorer, via RPC to Bitcoin Core";
    homepage = "https://github.com/janoside/btc-rpc-explorer";
    license = lib.licenses.mit;
    mainProgram = "btc-rpc-explorer";
  };
}
