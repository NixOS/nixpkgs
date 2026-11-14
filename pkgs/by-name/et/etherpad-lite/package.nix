{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "etherpad-lite";
  version = "3.3.17";

  src = fetchFromGitHub {
    owner = "ether";
    repo = "etherpad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/idVzI/xjf8b3eoZURYDHRbgDEH/dAbmjLF+0lSK4+s=";
  };

  patches = [
    ./outdir.patch
    # etherpad expects to read and write $out/lib/var/installed_plugins.json
    # FIXME: this patch disables plugin support
    ./dont-fail-on-plugins-json.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-TaUAWp4P2SD/+7uBi1P/60+u8gvJy+jeHS3I1DhufX8=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_12
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
    # Remove development dependencies without pnpm prune.
    rm -rf node_modules
    CI=true pnpm install --offline --frozen-lockfile --prod --ignore-scripts --config.trust-lockfile=true

    # Remove unnecessary files
    find -type f \( -name "*.d.ts" -o -name "*.map" \) -delete
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
      --suffix PATH : "${lib.makeBinPath [ pnpm_12 ]}" \
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
    changelog = "https://github.com/ether/etherpad/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      erdnaxe
      f2k1de
    ];
    license = lib.licenses.asl20;
    mainProgram = "etherpad-lite";
    platforms = lib.platforms.unix;
  };
})
