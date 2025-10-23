{
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
}:

(buildNpmPackage.override { inherit nodejs; }) rec {
  pname = "node-gyp";
  version = "11.5.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-gyp";
    tag = "v${version}";
    hash = "sha256-IymzSi9bQhtBX8AjtYAjHs0dN+5scywJuATz5IclSJs=";
  };

  npmDepsHash = "sha256-C8/pQ26gHToC0yq/6V385Uo1cM8SknoQ2h7u7i3Gy/Q=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
    substituteInPlace gyp/pylib/gyp/**.py \
      --replace-quiet sys.platform '"${stdenv.targetPlatform.parsed.kernel.name}"'
  '';

  dontNpmBuild = true;

  # Teach node-gyp to use nodejs headers locally rather that download them form https://nodejs.org.
  # This is important when build nodejs packages in sandbox.
  makeWrapperArgs = [ "--set npm_config_nodedir ${nodejs}" ];

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/nodejs/node-gyp/blob/${src.rev}/CHANGELOG.md";
    description = "Node.js native addon build tool";
    homepage = "https://github.com/nodejs/node-gyp";
    license = lib.licenses.mit;
    mainProgram = "node-gyp";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
