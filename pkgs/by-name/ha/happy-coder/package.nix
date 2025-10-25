{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "happy-coder";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "slopus";
    repo = "happy-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WKzbpxHqE3Dxqy/PDj51tM9+Wl2Pallfrc5UU2MxNn8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-3/qcbCJ+Iwc+9zPCHKsCv05QZHPUp0it+QR3z7m+ssw=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    makeWrapper
  ];

  # Build the TypeScript project
  yarnBuildScript = "build";

  installPhase = ''
    runHook preInstall

    # Install the package
    mkdir -p $out/lib/node_modules/happy-coder
    cp -r . $out/lib/node_modules/happy-coder/

    # Create bin directory and symlinks
    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/happy \
      --add-flags "$out/lib/node_modules/happy-coder/bin/happy.mjs"
    makeWrapper ${nodejs}/bin/node $out/bin/happy-mcp \
      --add-flags "$out/lib/node_modules/happy-coder/bin/happy-mcp.mjs"

    runHook postInstall
  '';

  meta = {
    description = "Mobile and web client wrapper for Claude Code and Codex with end-to-end encryption";
    homepage = "https://github.com/slopus/happy-cli";
    changelog = "https://github.com/slopus/happy-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onsails ];
    mainProgram = "happy";
  };
})
