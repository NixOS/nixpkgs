{
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
}:

buildNpmPackage rec {
  pname = "node-gyp";
  version = "12.3.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-gyp";
    tag = "v${version}";
    hash = "sha256-+QPQxWrO2n5QsyAmM5UfL/posEyQQGHmDG7EL0jBNeE=";
  };

  npmDepsHash = "sha256-43YHmebfSYNb7glSjycQqjnLY13Bp9syXRAWNDjBIXY=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
    substituteInPlace gyp/pylib/gyp/**.py \
      --replace-quiet sys.platform '"${stdenv.targetPlatform.parsed.kernel.name}"'
  '';

  inherit nodejs;

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
