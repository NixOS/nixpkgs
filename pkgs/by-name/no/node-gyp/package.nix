{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
}:

(buildNpmPackage.override { inherit nodejs; }) rec {
  pname = "node-gyp";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-gyp";
    rev = "refs/tags/v${version}";
    hash = "sha256-AxyGE86nuU9VkbLLR/8GKM6bcTgayYodQ0mWiQhQtA0=";
  };

  npmDepsHash = "sha256-LCm1gF7GfjT13k3fe1A+DNNwP48OtFVbYgwCCLH3eHA=";

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
