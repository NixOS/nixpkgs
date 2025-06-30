{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  nix-update-script,
}:

let
  # TODO: remove once in a release
  packageLock = fetchurl {
    url = "https://github.com/nodejs/node-core-utils/raw/7d5ac23df66c9ee12ed4837da85fe8ea4b1f7280/package-lock.json";
    hash = "sha256-stQiXCdfaSfTJqQr0oZeOpFfPsjIRWtRCwcAcd/QJtU=";
  };
in
buildNpmPackage rec {
  pname = "node-core-utils";
  version = "5.14.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-core-utils";
    tag = "v${version}";
    hash = "sha256-OmUsb86SfZ72sojH7EKbAYE9KV8afrAmKI2RWyHDmS4=";
  };

  npmDepsHash = "sha256-z9IvBpT+EmR0aTeP6bvIhDb9OIzW5miOdZ4EiyobGXo=";

  # Upstream doesn't provide any lock file so we provide our own:
  postPatch = ''
    cp ${packageLock} package-lock.json
  '';

  dontNpmBuild = true;
  dontNpmPrune = true;
  npmInstallFlags = [ "--omit=dev" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (src.meta) homepage;
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.tag}/CHANGELOG.md";
    description = "CLI tools for Node.js Core collaborators";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
}
