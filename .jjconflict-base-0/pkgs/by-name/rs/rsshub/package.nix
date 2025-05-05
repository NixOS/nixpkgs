{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  pnpm_9,
  replaceVars,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rsshub";
  version = "0-unstable-2025-02-03";

  src = fetchFromGitHub {
    owner = "DIYgod";
    repo = "RSSHub";
    rev = "72f78e2bfbcf000a6f374a92894430cf845fd1fd";
    hash = "sha256-okavLIYJZ+0iCsYtBc2r3FS18MVE/ap2OwRae7rWTrw=";
  };

  patches = [
    (replaceVars ./0001-fix-git-hash.patch {
      "GIT_HASH" = finalAttrs.src.rev;
    })
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-c16Ue5YiRWlF7ldt/8WLi1/xYhGqqr6XqvUieQbvbWg=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm_9.configHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/rsshub
    cp -r lib node_modules assets api package.json tsconfig.json $out/lib/rsshub

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/rsshub \
      --chdir "$out/lib/rsshub" \
      --set "NODE_ENV" "production" \
      --set "NO_LOGFILES" "true" \
      --set "TSX_TSCONFIG_PATH" "$out/lib/rsshub/tsconfig.json" \
      --append-flags "$out/lib/rsshub/node_modules/tsx/dist/cli.mjs" \
      --append-flags "$out/lib/rsshub/lib/index.ts"
  '';

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
    maintainers = with lib.maintainers; [ Guanran928 ];
    mainProgram = "rsshub";
    platforms = lib.platforms.all;
  };
})
