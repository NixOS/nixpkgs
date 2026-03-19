{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  lib,
  nixosTests,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "node-red";
  version = "4.1.7";

  src = fetchFromGitHub {
    owner = "node-red";
    repo = "node-red";
    tag = version;
    hash = "sha256-J7LwIXicEMlWtnO1dXjipVOOQQKUB2bc8uJu0Yd/J7s=";
  };

  npmDepsHash = "sha256-OiaUGSpSiQoQlwh28FZcKD1lPjt6VrTLu0KuOfAg2IE=";

  nativeBuildInputs = [ jq ];

  postPatch =
    let
      packageDir = "packages/node_modules/node-red";
    in
    ''
      ${lib.getExe jq} '. += {"bin": {"node-red": "${packageDir}/red.js", "node-red-pi": "${packageDir}/bin/node-red-pi"}}' package.json > package.json.tmp
      mv package.json.tmp package.json
    '';

  makeCacheWritable = true;

  passthru = {
    tests = {
      inherit (nixosTests) node-red;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/node-red/node-red/blob/${src.tag}/CHANGELOG.md";
    description = "Low-code programming for event-driven applications";
    homepage = "https://nodered.org/";
    license = lib.licenses.asl20;
    mainProgram = "node-red";
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
