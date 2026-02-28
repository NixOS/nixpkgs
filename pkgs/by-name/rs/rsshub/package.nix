{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  replaceVars,
  stdenv,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rsshub";
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "DIYgod";
    repo = "RSSHub";
    rev = "1acb8057995a446574827b6e3e756de462e8f6be";
    hash = "sha256-I89mEL93rktDZdeSCQp6N6JCp7k93jvKS74ALXz6GUs=";
  };

  patches = [
    (replaceVars ./0001-fix-git-hash.patch {
      "GIT_HASH" = finalAttrs.src.rev;
    })
    ./0002-bypass-route-build.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 2;
    hash = "sha256-F6+ZBCqNxTM59xslvS56EcuoLh3ptw34Y6W+KkZv9Mg=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild

    # build routes at first.
    export BUILD_ROUTES_MODE=1
    pnpm run build:routes
    unset BUILD_ROUTES_MODE

    # build application
    pnpm build

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
      --chdir "$out/lib/rsshub" \
      --set "NODE_ENV" "production" \
      --set "NO_LOGFILES" "true" \
      --set "TSX_TSCONFIG_PATH" "$out/lib/rsshub/tsconfig.json" \
      --append-flags "$out/lib/rsshub/dist/index.mjs"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=master" ];
  };

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xinyangli
      vonfry
    ];
    mainProgram = "rsshub";
    platforms = lib.platforms.all;
  };
})
