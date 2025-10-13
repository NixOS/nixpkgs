{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pnpm_9,
  makeWrapper,
  nodejs,
}:

let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "etherpad-lite";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "ether";
    repo = "etherpad-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-11fNDAR6zmHv1O5nL0GhGJj6eHwDc8zT0Tvrba7qBpw=";
  };

  patches = [
    ./outdir.patch
    # etherpad expects to read and write $out/lib/var/installed_plugins.json
    # FIXME: this patch disables plugin support
    ./dont-fail-on-plugins-json.patch
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-PZD55V/3dvNLx39tD4I00IzURhuyqMX4uObnQfnSBtk=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    makeWrapper
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild
    NODE_ENV="production" pnpm run build:etherpad
    runHook postBuild
  '';

  preInstall = ''
    # remove unnecessary files
    rm node_modules/.modules.yaml
    CI=true pnpm prune --prod --ignore-scripts
    find -type f \( -name "*.d.ts" -o -name "*.map" \) -exec rm -rf {} +

    # remove non-deterministic files
    rm node_modules/.modules.yaml
  '';

  # Upstream scripts uses `pnpm run prod` which is equivalent to
  # `cross-env NODE_ENV=production node --require tsx/cjs node/server.ts`
  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib/etherpad-lite,bin}
    cp -r node_modules ui src doc admin $out/lib/etherpad-lite
    makeWrapper ${lib.getExe nodejs} $out/bin/etherpad-lite \
      --inherit-argv0 \
      --add-flags "--require tsx/cjs $out/lib/etherpad-lite/node_modules/ep_etherpad-lite/node/server.ts" \
      --suffix PATH : "${lib.makeBinPath [ pnpm ]}" \
      --set NODE_PATH "$out/lib/node_modules:$out/lib/etherpad-lite/node_modules/ep_etherpad-lite/node_modules" \
      --set-default NODE_ENV production
    find $out/lib -xtype l -delete
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern really-real-time collaborative document editor";
    longDescription = ''
      Etherpad is a real-time collaborative editor scalable to thousands of simultaneous real time users.
      It provides full data export capabilities, and runs on your server, under your control.
    '';
    homepage = "https://etherpad.org/";
    changelog = "https://github.com/ether/etherpad-lite/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      erdnaxe
      f2k1de
    ];
    license = lib.licenses.asl20;
    mainProgram = "etherpad-lite";
    platforms = lib.platforms.unix;
  };
})
