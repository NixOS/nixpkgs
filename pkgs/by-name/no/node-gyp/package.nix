{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
}:

(buildNpmPackage.override { inherit nodejs; }) rec {
  pname = "node-gyp";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-gyp";
    rev = "refs/tags/v${version}";
    hash = "sha256-uC75nDZPSDLsRIXyFs1hwhRMcECQB8iycNe9wtZjJ/E=";
  };

  npmDepsHash = "sha256-RR6thRyl+tz0xQPwzTb03Zbt+IQTYZhnii3lrQXaZpI=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
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
