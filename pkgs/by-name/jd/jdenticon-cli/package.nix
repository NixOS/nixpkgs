{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "jdenticon-cli";
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "dmester";
    repo = "jdenticon";
    tag = finalAttrs.version;
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/dmester/jdenticon/releases/tag/${finalAttrs.version}";
    description = "JavaScript library for generating highly recognizable identicons using HTML5 canvas or SVG.";
    homepage = "https://jdenticon.com/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gipphe ];
    mainProgram = "jdenticon";
  };
})
