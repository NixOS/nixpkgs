{
  buildNpmPackage,
  makeWrapper,
  nodejs,
  fetchFromGitHub,
  lib,
}:
let
  version = "3.3.0";
in
buildNpmPackage {
  pname = "jdenticon-cli";
  inherit version;
  src = fetchFromGitHub {
    owner = "dmester";
    repo = "jdenticon";
    rev = version;
    hash = "sha256-uOPNsfEreC7F+Y0WWmudZSPnGxqarna0JPOwQyK6LiQ=";
  };
  npmDepsHash = "sha256-LXwvb088oHmA57EryfYtKi0L/9sB+yyUr/K/qGA1W9k=";

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    install -D bin/jdenticon.js "$out/lib/jdenticon/bin/jdenticon.js"
    install -D dist/jdenticon-node.js "$out/lib/jdenticon/dist/jdenticon-node.js"
    install -d "$out/lib/jdenticon/node_modules"
    cp -r node_modules/canvas-renderer  "$out/lib/jdenticon/node_modules"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/jdenticon" \
      --add-flags "$out/lib/jdenticon/bin/jdenticon.js"

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/dmester/jdenticon/releases/tag/${version}";
    description = "JavaScript library for generating highly recognizable identicons using HTML5 canvas or SVG.";
    homepage = "https://jdenticon.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ gipphe ];
    mainProgram = "jdenticon";
  };
}
