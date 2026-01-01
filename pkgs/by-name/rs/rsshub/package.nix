{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  replaceVars,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rsshub";
  version = "0-unstable-2025-11-28";
=======
  replaceVars,
  stdenv,
}:
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rsshub";
  version = "0-unstable-2025-05-31";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DIYgod";
    repo = "RSSHub";
<<<<<<< HEAD
    rev = "b6dbafe33e0c3e3a4ba5a1edd2da29b70412389f";
    hash = "sha256-FsevO2nb6leuuRmzCLIy093FCafl3Y/CsSp1ydJOnKY=";
=======
    rev = "2dce2e32dd5f4dade2fc915ac8384c953e11cc83";
    hash = "sha256-gS/t6O3MishJgi2K9hV22hT95oYHfm44cJqrUo2GPlM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    (replaceVars ./0001-fix-git-hash.patch {
      "GIT_HASH" = finalAttrs.src.rev;
    })
    ./0002-fix-network-call.patch
  ];

<<<<<<< HEAD
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-zTsJZnhX7xUOsKST6S3TQUV8M1Tewcs9fZgrDSf5ba8=";
=======
  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-7qh6YZbIH/kHVssDZxHY7X8bytrnMcUq0MiJzWZYItc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
=======
    pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
<<<<<<< HEAD
    mkdir -p $out/bin $out/lib/rsshub/lib
    cp -r dist node_modules $out/lib/rsshub
    cp -r lib/assets $out/lib/rsshub/lib
=======
    mkdir -p $out/bin $out/lib/rsshub
    cp -r lib node_modules assets api package.json tsconfig.json $out/lib/rsshub
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/rsshub \
      --chdir "$out/lib/rsshub" \
      --set "NODE_ENV" "production" \
      --set "NO_LOGFILES" "true" \
      --set "TSX_TSCONFIG_PATH" "$out/lib/rsshub/tsconfig.json" \
<<<<<<< HEAD
      --append-flags "$out/lib/rsshub/dist/index.mjs"
=======
      --append-flags "$out/lib/rsshub/node_modules/tsx/dist/cli.mjs" \
      --append-flags "$out/lib/rsshub/lib/index.ts"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ xinyangli ];
=======
    maintainers = with lib.maintainers; [ Guanran928 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rsshub";
    platforms = lib.platforms.all;
  };
})
