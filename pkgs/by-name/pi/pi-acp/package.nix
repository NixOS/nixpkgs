{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  pi-coding-agent,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-acp";
  version = "0.0.34";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "svkozak";
    repo = "pi-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QRwxOtTZOY+Np3PkAoy2o2PrUzEqjItM/372sCPlSMo=";
  };

  npmDepsHash = "sha256-BvLNtFfp1cMVjzWcMRSdhTqiJrTfbFoUbWkkPW9200o=";

  postPatch = ''
    # Run pi from nixpkgs unless PI_ACP_PI_COMMAND says otherwise. In the source rather than a
    # wrapper: ACP clients start the terminal login as `node dist/index.js --terminal-login`.
    substituteInPlace src/pi-rpc/command.ts \
      --replace-fail ": 'pi'" ": '${lib.getExe pi-coding-agent}'"
    substituteInPlace test/unit/pi-command.test.ts \
      --replace-fail "defaultPiCommand(), 'pi')" "defaultPiCommand(), '${lib.getExe pi-coding-agent}')"
    # The version shown at session start
    substituteInPlace src/acp/agent.ts \
      --replace-fail "spawnSync('pi', ['--version']" "spawnSync('${lib.getExe pi-coding-agent}', ['--version']"

    # The tests write fake `pi` launchers with a `#!/usr/bin/env node` shebang; the build sandbox
    # has no /usr/bin/env.
    substituteInPlace test/unit/pi-rpc-session-path.test.ts \
      --replace-fail '#!/usr/bin/env node' '#!${lib.getExe nodejs}'
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent Client Protocol adapter for the pi coding agent";
    homepage = "https://github.com/svkozak/pi-acp";
    changelog = "https://github.com/svkozak/pi-acp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kleinbem ];
    mainProgram = "pi-acp";
  };
})
