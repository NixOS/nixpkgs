{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  lib,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "node-red";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "node-red";
    repo = "node-red";
    tag = version;
    hash = "sha256-Xr00S9Q8EPPGcd3kNHjmqYuzdzN6+W8xVuJsUVr4yII=";
  };

  npmDepsHash = "sha256-8nwIEu/p5kVYoG3+jXBss352MciCnk/aGV9nbDGHDdA=";

  nativeBuildInputs = [ jq ];

  postPatch =
    let
      packageDir = "packages/node_modules/node-red";
    in
    ''
      ln -s ${./package-lock.json} package-lock.json

      jq '. += {"bin": {"node-red": "${packageDir}/red.js", "node-red-pi": "${packageDir}/bin/node-red-pi"}}' package.json > package.json.tmp
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
