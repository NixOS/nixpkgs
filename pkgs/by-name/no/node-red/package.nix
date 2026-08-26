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
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "node-red";
    repo = "node-red";
    tag = version;
    hash = "sha256-pFjo5Cm7PCVswqTRlQEQKVXzPq3Of7PItBJkUU2iiAs=";
  };

  npmDepsHash = "sha256-ETppuZGzAZ4w9WFY3ppmBNNXv22+ScFmHEqU89NKXqI=";

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
    maintainers = with lib.maintainers; [
      adamcstephens
      matthewcroughan
    ];
  };
}
