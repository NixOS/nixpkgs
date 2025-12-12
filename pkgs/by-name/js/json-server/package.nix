{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "json-server";
  version = "1.0.0-beta.3";

  src = fetchFromGitHub {
    owner = "typicode";
    repo = "json-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NDSmlW5SiA81Tf6kfkaaKUh05aGZEBajqkLZoxBv0Wc=";
  };

  npmDepsHash = "sha256-HZmCxMKgxJ+ZiRDXh/iVmytNMbPoYzSuI0F8YmkcfZI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    description = "Get a full fake REST API with zero coding in less than 30 seconds";
    homepage = "https://github.com/typicode/json-server";
    license = lib.licenses.fairsource09;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
