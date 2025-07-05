{
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
}:

(buildNpmPackage.override { inherit nodejs; }) rec {
  pname = "node-gyp";
  version = "11.2.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-gyp";
    tag = "v${version}";
    hash = "sha256-NOVswjTByrQ+2z4H9wYd4YIWKhWIdgxpz2pE0dOK6qc=";
  };

  npmDepsHash = "sha256-emCYKqe6Bn1hmUq9jPDo5Nu9n43s4kb0E8lQndVtmlQ=";

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
