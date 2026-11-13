{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  makeWrapper,
  nix-update-script,
  nodejs_24,
  nodejs-slim_24,
  npm-lockfile-fix,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "rtl";
  version = "0.15.17";

  src = fetchFromGitHub {
    owner = "Ride-The-Lightning";
    repo = "RTL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u/ok8DdIGEgB6m/+o2wi9YHv+Gr7yRiA9pM7yj447lU=";

    # Upstream's lockfile omits resolved URLs and integrity hashes for most dependencies.
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  # Match upstream's Docker image and its supported Node.js versions.
  nodejs = nodejs_24;

  npmDepsHash = "sha256-la6umzjzE0CUYxbcw0CqAApsLA7d4OVpOZAtJB0n35M=";
  # Some dependencies require Angular 21, while upstream still uses Angular 20.
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = "buildfrontend";

  nativeBuildInputs = [
    jq
    makeWrapper
  ];

  buildInputs = [ nodejs-slim_24 ];

  env.CI = true;

  postPatch = ''
    # Default to storing the database with the configuration, outside the Nix store.
    substituteInPlace server/utils/config.ts \
      --replace-fail "join(dirname(fileURLToPath(import.meta.url)), '..', '..')" \
        "config.rtlConfFilePath"
  '';

  preBuild = ''
    # Build both components from source instead of using the committed bundles.
    rm -r frontend backend
  '';

  postBuild = ''
    npm run buildbackend
  '';

  doCheck = true;
  # The backend tests start local HTTP servers.
  __darwinAllowLocalNetworking = true;
  checkPhase = ''
    runHook preCheck

    npm run testbackend

    runHook postCheck
  '';

  preInstall = ''
    jq '.files = ["rtl.js", "frontend", "backend"]' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  postInstall = ''
    # Replace the build-time Node.js shebangs with the slim runtime.
    patchShebangs --host --update "$out/lib/node_modules/rtl/node_modules"

    # Keep the default configuration directory outside the Nix store.
    makeWrapper ${lib.getExe nodejs-slim_24} $out/bin/rtl \
      --set-default RTL_CONFIG_PATH . \
      --add-flags "$out/lib/node_modules/rtl/rtl.js"

    install -Dm644 Sample-RTL-Config.json $out/share/doc/rtl/Sample-RTL-Config.json
  '';

  outputChecks.out.disallowedRequisites = [
    nodejs_24
    nodejs-slim_24.npm
    nodejs-slim_24.corepack
    nodejs-slim_24.python
    finalAttrs.npmDeps
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web interface for LND, Core Lightning and Eclair";
    homepage = "https://github.com/Ride-The-Lightning/RTL";
    changelog = "https://github.com/Ride-The-Lightning/RTL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    mainProgram = "rtl";
  };
})
