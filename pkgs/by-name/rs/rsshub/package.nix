{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  replaceVars,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rsshub";
  version = "2026.11.03-8565.53c4e54";

  src = fetchFromGitHub {
    owner = "DIYgod";
    repo = "RSSHub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1TUmbdmVMEZ9C9vmd5I4GiGg1RqtjDUwODxhQT27Gc0=";
  };

  patches = [
    (replaceVars ./0001-fix-git-hash.patch {
      GIT_HASH = lib.last (lib.splitString "." finalAttrs.version);
    })
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 5;
    hash = "sha256-uypVk5hiymS6ZBchGo9r1XceADIqSHuBnyMIGHz7vnw=";
    pnpm = pnpm_12;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm_12
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  preInstall = ''
    CI=true pnpm prune --prod --ignore-scripts
    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/rsshub/lib
    cp -r dist node_modules $out/lib/rsshub
    cp -r lib/assets $out/lib/rsshub/lib
    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/rsshub \
      --set "NODE_ENV" "production" \
      --set "NO_LOGFILES" "true" \
      --add-flags "$out/lib/rsshub/dist/index.mjs"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "RSS feed generator";
    longDescription = ''
      RSSHub is an open source, easy to use, and extensible RSS feed generator.
      It's capable of generating RSS feeds from pretty much everything.

      RSSHub delivers millions of contents aggregated from all kinds of sources,
      our vibrant open source community is ensuring the deliver of RSSHub's new routes,
      new features and bug fixes.
    '';
    homepage = "https://docs.rsshub.app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      xinyangli
      davinci42
    ];
    mainProgram = "rsshub";
    platforms = lib.platforms.all;
  };
})
