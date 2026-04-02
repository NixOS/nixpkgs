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
  version = "0-unstable-2026-03-24";

  src = fetchFromGitHub {
    owner = "DIYgod";
    repo = "RSSHub";
    rev = "df6b73d8663c0ba4c11bae89a61cf0b87c8c52a5";
    hash = "sha256-6YasIbThh5S7UH7WFVEdl++96hL3BEmxdp/QAAzIm18=";
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
    hash = "sha256-uzPDx48dWAguQ3PolTWz0HDtnO6qBVlKpJRn+ub7mM0=";
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
