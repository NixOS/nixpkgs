{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
}:

(buildNpmPackage.override { inherit nodejs; }) rec {
  pname = "node-gyp";
  version = "10.3.1";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-gyp";
    rev = "refs/tags/v${version}";
    hash = "sha256-Emq8JC6URFHSigRm+6yY/xX4SeZJKsBE2dXN1aWYxOU=";
  };

  npmDepsHash = "sha256-/ERbWveCePkKQjeArSYN/tK6c6Op5wtI/2RxBV0ylo4=";

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
