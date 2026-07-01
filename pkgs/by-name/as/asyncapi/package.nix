{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "asyncapi";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "asyncapi";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AvEzwUMXZZRexlcYbD4iW2GYmndN0usFxYJclXst57g=";
  };

  npmDepsHash = "sha256-f+1KRqPIufMoSv6pa7CAd8fvG8uigNjr6QE6leVCtUI=";

  env.PUPPETEER_SKIP_DOWNLOAD = "true";

  postPatch = ''
    # The build script fetches AsyncAPI examples from the internet.
    # Replace with a no-op since the CLI works without bundled examples.
    mkdir -p assets/examples
    echo '[]' > assets/examples/examples.json
    substituteInPlace package.json \
      --replace-fail "node scripts/fetch-asyncapi-example.js && " ""

    # The logger tries to create a logs directory relative to __dirname,
    # which ends up inside the read-only Nix store. Use a writable path instead.
    substituteInPlace src/utils/logger.ts \
      --replace-fail "path.join(__dirname, config.has('log.dir') ? config.get('log.dir') : 'logs')" \
        "path.join(process.env.XDG_STATE_HOME || path.join(require('os').homedir(), '.local', 'state'), 'asyncapi', 'logs')" \
      --replace-fail "fs.mkdirSync(logDir)" \
        "fs.mkdirSync(logDir, { recursive: true })"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI to work with your AsyncAPI files. You can validate them and in the future use a generator and even bootstrap a new file";
    homepage = "https://www.asyncapi.com/tools/cli";
    changelog = "https://github.com/asyncapi/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pmyjavec ];
    mainProgram = "asyncapi";
  };
})
