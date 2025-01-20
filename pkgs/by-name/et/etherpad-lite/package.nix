{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  pnpm,
  makeWrapper,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "etherpad-lite";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "ether";
    repo = "etherpad-lite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B//EwfXS0BXxkksvB1EZZaZuPuruTZ3FySj9B5y0iBw=";
  };

  patches = [
    (fetchpatch {
      name = "use-tmp-dir-esbuild.patch";
      url = "https://github.com/ether/etherpad-lite/commit/e881a383b38d4d80ee28c17a14b5de58889245de.patch";
      hash = "sha256-svRkaW2nqLLAmWtEgaur5BORUNvRnDYLHM1FD7b1cFU=";
    })

    # etherpad expects to read and write $out/lib/var/installed_plugins.json
    # FIXME: this patch disables plugin support
    ./dont-fail-on-plugins-json.patch
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-IdnlJmjgOMR04WwAEabepD4DWJyXii7XzS5v27Y1LHY=";
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

  # Upstream scripts uses `pnpm run prod` which is equivalent to
  # `cross-env NODE_ENV=production node --require tsx/cjs node/server.ts`
  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib,bin}
    cp -r node_modules ui src doc admin $out/lib
    makeWrapper ${lib.getExe nodejs} $out/bin/etherpad-lite \
      --inherit-argv0 \
      --add-flags "--require tsx/cjs $out/lib/node_modules/ep_etherpad-lite/node/server.ts" \
      --suffix PATH : "${lib.makeBinPath [ pnpm ]}" \
      --set NODE_PATH "$out/lib/node_modules:$out/lib/node_modules/ep_etherpad-lite/node_modules" \
      --set-default NODE_ENV production
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Modern really-real-time collaborative document editor";
    longDescription = ''
      Etherpad is a real-time collaborative editor scalable to thousands of simultaneous real time users.
      It provides full data export capabilities, and runs on your server, under your control.
    '';
    homepage = "https://etherpad.org/";
    changelog = "https://github.com/ether/etherpad-lite/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.asl20;
    mainProgram = "etherpad-lite";
    platforms = lib.platforms.unix;
  };
})
