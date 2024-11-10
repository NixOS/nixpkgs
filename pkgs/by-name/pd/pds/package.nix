{
  stdenv,
  makeBinaryWrapper,
  removeReferencesTo,
  srcOnly,
  python3,
  pnpm_9,
  fetchFromGitHub,
  nodejs,
  vips,
  pkg-config,
  nixosTests,
  lib,
}:

let
  nodeSources = srcOnly nodejs;
  pythonEnv = python3.withPackages (p: [ p.setuptools ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pds";
  version = "0.4.74";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "pds";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kNHsQ6funmo8bnkFBNWHQ0Fmd5nf/uh+x9buaRJMZnM=";
  };

  sourceRoot = "${finalAttrs.src.name}/service";

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pythonEnv
    pkg-config
    pnpm_9.configHook
    removeReferencesTo
  ];

  # Required for `sharp` NPM dependency
  buildInputs = [ vips ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-oU4dwlBdsMmgAUv1ICaOqaqucmg/TjKOZxjnxpm0qL8=";
  };

  buildPhase = ''
    runHook preBuild

    pushd ./node_modules/.pnpm/better-sqlite3@*/node_modules/better-sqlite3
    npm run build-release --offline --nodedir="${nodeSources}"
    find build -type f -exec remove-references-to -t "${nodeSources}" {} \;
    popd

    makeWrapper "${lib.getExe nodejs}" "$out/bin/pds" \
      --add-flags --enable-source-maps \
      --add-flags "$out/lib/pds/index.js" \
      --set-default NODE_ENV production

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/pds}
    mv node_modules $out/lib/pds
    mv index.js $out/lib/pds

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) pds;
  };

  meta = {
    description = "Bluesky Personal Data Server (PDS)";
    homepage = "https://github.com/bluesky-social/pds";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.unix;
    mainProgram = "pds";
  };
})
