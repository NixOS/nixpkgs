{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  overrideSDK,
  pnpm_9,
  python3,
  renovate,
  testers,
  xcbuild,
}:

let
  # fix build error, `no member named 'aligned_alloc'` on x86_64-darwin
  # https://github.com/NixOS/nixpkgs/issues/272156#issuecomment-1839904283
  stdenv' = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "renovate";
  version = "37.393.0";

  src = fetchFromGitHub {
    owner = "renovatebot";
    repo = "renovate";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-YgxcGNMgmwrausdR7kvG1NiyQPn0FcCq/isf9qUDCFY=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "0.0.0-semantic-release" "${finalAttrs.version}"
  '';

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm_9.configHook
    python3
  ] ++ lib.optional stdenv'.hostPlatform.isDarwin xcbuild;

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Zbe561q6xDKDIN+E/2eyQMz2GtpPvJEv2pAauMa+8pE=";
  };

  env.COREPACK_ENABLE_STRICT = 0;

  buildPhase =
    ''
      runHook preBuild

      pnpm build
      pnpm prune --prod --ignore-scripts
    ''
    # The optional dependency re2 is not built by pnpm and needs to be built manually.
    # If re2 is not built, you will get an annoying warning when you run renovate.
    + ''
      pushd node_modules/.pnpm/re2*/node_modules/re2

      mkdir -p $HOME/.node-gyp/${nodejs.version}
      echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
      export npm_config_nodedir=${nodejs}
      npm run rebuild

      popd

      runHook postBuild
    '';

  # TODO: replace with `pnpm deploy`
  # now it fails to build with ERR_PNPM_NO_OFFLINE_META
  # see https://github.com/pnpm/pnpm/issues/5315
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/node_modules/renovate}
    cp -r dist node_modules package.json $out/lib/node_modules/renovate

    makeWrapper "${lib.getExe nodejs}" "$out/bin/renovate" \
      --add-flags "$out/lib/node_modules/renovate/dist/renovate.js"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/config-validator" \
      --add-flags "$out/lib/node_modules/renovate/dist/config-validator.js"

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion { package = renovate; };
  };

  meta = {
    description = "Cross-platform Dependency Automation by Mend.io";
    homepage = "https://github.com/renovatebot/renovate";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      marie
      natsukium
    ];
    mainProgram = "renovate";
    platforms = nodejs.meta.platforms;
  };
})
