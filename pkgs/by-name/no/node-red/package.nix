{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  lib,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "node-red";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "node-red";
    repo = "node-red";
    tag = version;
    hash = "sha256-MBuWVrN5KNUSNRMZTrDwkQjf3E7BPpnYZL0LKSd6dvU=";
  };

  npmDepsHash = "sha256-FV+41HMggMMadRQG/jVnTkp4ycAthp+a4QPrTRhuris=";

  postPatch =
    let
      packageDir = "packages/node_modules/node-red";
    in
    ''
      ln -s ${./package-lock.json} package-lock.json

      ${lib.getExe jq} '. += {"bin": {"node-red": "${packageDir}/red.js", "node-red-pi": "${packageDir}/bin/node-red-pi"}}' package.json > package.json.tmp
      mv package.json.tmp package.json
    '';

  makeCacheWritable = true;

  passthru = {
    tests = {
      inherit (nixosTests) node-red;
    };
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://github.com/node-red/node-red/blob/${src.rev}/CHANGELOG.md";
    description = "Low-code programming for event-driven applications";
    homepage = "https://nodered.org/";
    license = lib.licenses.asl20;
    mainProgram = "node-red";
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
