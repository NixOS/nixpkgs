{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "node-core-utils";
  version = "5.14.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-core-utils";
    rev = "v${version}";
    hash = "sha256-OmUsb86SfZ72sojH7EKbAYE9KV8afrAmKI2RWyHDmS4=";
  };

  npmDepsHash = "sha256-z9IvBpT+EmR0aTeP6bvIhDb9OIzW5miOdZ4EiyobGXo=";

  # Upstream doesn't provide any lock file so we provide our own:
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;
  dontNpmPrune = true;
  npmInstallFlags = [ "--omit=dev" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/CHANGELOG.md";
    description = "CLI tools for Node.js Core collaborators";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
}
