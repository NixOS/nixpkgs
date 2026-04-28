{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  replaceVars,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rsshub";
  version = "0-unstable-2026-04-27";

  src = fetchFromGitHub {
    owner = "DIYgod";
    repo = "RSSHub";
    rev = "add0734e0f8c88af8e81e80f0d4ab70ad9ed920e";
    hash = "sha256-IVVCOSXXCSsSVM1cczX3oTpd07uaJ2LAWMJxMylkRt0=";
  };

  patches = [
    (replaceVars ./0001-fix-git-hash.patch {
      GIT_HASH = finalAttrs.src.rev;
    })
    ./0002-fix-network-call.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-zGchfq2Slr5GzeQrp+0JG+BlI/NPObJ7SJSn1I2MHQ0=";
    pnpm = pnpm_10;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildPhase = ''
    runHook preBuild
    # First build route metadata using directoryImport (avoids executing
    # module-level code that would trigger network requests)
    BUILD_ROUTES_MODE=1 pnpm run build:routes
    # Then build the application
    pnpm run build
    runHook postBuild
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

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
    maintainers = with lib.maintainers; [ xinyangli ];
    mainProgram = "rsshub";
    platforms = lib.platforms.all;
  };
})
