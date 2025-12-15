{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  pnpm_9,
  replaceVars,
  stdenv,
}:
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rsshub";
  version = "0-unstable-2025-11-28";

  src = fetchFromGitHub {
    owner = "DIYgod";
    repo = "RSSHub";
    rev = "b6dbafe33e0c3e3a4ba5a1edd2da29b70412389f";
    hash = "sha256-FsevO2nb6leuuRmzCLIy093FCafl3Y/CsSp1ydJOnKY=";
  };

  patches = [
    (replaceVars ./0001-fix-git-hash.patch {
      "GIT_HASH" = finalAttrs.src.rev;
    })
    ./0002-fix-network-call.patch
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-zTsJZnhX7xUOsKST6S3TQUV8M1Tewcs9fZgrDSf5ba8=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm.configHook
  ];

  buildPhase = ''
    runHook preBuild
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
    maintainers = with lib.maintainers; [ xinyangli ];
    mainProgram = "rsshub";
    platforms = lib.platforms.all;
  };
})
