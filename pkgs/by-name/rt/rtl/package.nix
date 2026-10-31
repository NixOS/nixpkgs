{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  makeWrapper,
  nix-update-script,
  nodejs_22,
  nodejs-slim_22,
  npm-lockfile-fix,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "rtl";
  version = "0.15.15";

  src = fetchFromGitHub {
    owner = "Ride-The-Lightning";
    repo = "RTL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Se93VGIkrSvkSOyFsp4K9dJslXsT8Tm5jXyKNnex7Y8=";

    # Upstream's lockfile omits resolved URLs and integrity hashes for most dependencies.
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  # Match upstream's Docker image and its supported Node.js versions.
  nodejs = nodejs_22;

  npmDepsHash = "sha256-l+/1YNGfg1xKzBpA6+MnCjNssNyfofcrWBzam4xb83Q=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = "buildfrontend";

  nativeBuildInputs = [
    jq
    makeWrapper
  ];

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
    # Keep the default configuration directory outside the Nix store.
    makeWrapper ${lib.getExe nodejs-slim_22} $out/bin/rtl \
      --set-default RTL_CONFIG_PATH . \
      --add-flags "$out/lib/node_modules/rtl/rtl.js"

    install -Dm644 Sample-RTL-Config.json $out/share/doc/rtl/Sample-RTL-Config.json
  '';

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
