{
  autoPatchelfHook,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  libuv,
  makeWrapper,
  nix-update-script,
  nodejs_22,
  python3,
  stdenv,
}:

buildNpmPackage (finalAttrs: {
  pname = "paseo";
  version = "0.10.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "getpaseo";
    repo = "paseo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yI/H8XPC0lLdmokePJ4qyVxaV+/PsgePzQupumm5LPQ=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-uG7EkoQMVLk5CzDEbJbR5aPxeq59x4vjF21JGatxD7k=";

  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    python3
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libuv
    stdenv.cc.cc.lib
  ];

  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    npm_config_build_from_source=true npm_config_nodedir=${finalAttrs.nodejs} \
      npm rebuild node-pty --workspace @getpaseo/server

    npm run build:server
    npm run build:daemon-web-ui

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Compute the daemon's runtime closure by static module-graph tracing
    mkdir -p $out/lib/paseo
    node scripts/trace-daemon.mjs > daemon-files.txt

    while IFS= read -r path; do
      [ -z "$path" ] && continue
      mkdir -p "$out/lib/paseo/$(dirname "$path")"
      cp -a "$path" "$out/lib/paseo/$path"
    done < daemon-files.txt

    # The CLI resolves this export to locate the supervisor without loading it.
    cp packages/server/dist/server/server/exports.js \
      $out/lib/paseo/packages/server/dist/server/server/

    nodePty=packages/server/node_modules/node-pty
    mkdir -p "$out/lib/paseo/$nodePty/build"
    cp -a "$nodePty/build/Release" "$out/lib/paseo/$nodePty/build/"

    # Root package.json lets node resolve the workspace layout when the
    # CLI/server bin starts from $out.
    cp package.json $out/lib/paseo/

    cp -r packages/server/dist/server/web-ui $out/lib/paseo/packages/server/dist/server/

    mkdir -p $out/bin

    makeWrapper ${finalAttrs.nodejs}/bin/node $out/bin/paseo-server \
      --add-flags "$out/lib/paseo/packages/server/dist/scripts/supervisor-entrypoint.js" \
      --set PASEO_NODE_ENV production

    makeWrapper ${finalAttrs.nodejs}/bin/node $out/bin/paseo \
      --add-flags "$out/lib/paseo/packages/cli/dist/index.js" \
      --set NODE_PATH "$out/lib/paseo/node_modules"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Orchestrate multiple coding agents from desktop and mobile";
    homepage = "https://github.com/getpaseo/paseo";
    changelog = "https://github.com/getpaseo/paseo/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "paseo";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
