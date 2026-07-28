{
  stdenv,
  makeBinaryWrapper,
  removeReferencesTo,
  srcOnly,
  python3,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nodejs_24,
  vips,
  pkg-config,
  nixosTests,
  lib,
  nix-update-script,
  cctools,
  fetchpatch2,
}:

let
  # upstream bluesky-social/atproto uses nodejs 22+
  nodejs = nodejs_24;
  nodeSources = srcOnly nodejs;
  pythonEnv = python3.withPackages (p: [ p.setuptools ]);
  pnpm = pnpm_10;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pds";
  version = "0.4.5009";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "pds";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3IEbVn7ThiVL7E2fXMHzsRSLT7Tm1eiX8bPQ88rJCvs=";
  };

  sourceRoot = "${finalAttrs.src.name}/service";

  patchFlags = [ "-p2" ];
  patches = [
    (fetchpatch2 {
      url = "https://github.com/bluesky-social/pds/commit/f8de5f08900c42023b01a4d10995556f16d05145.patch?full_index=1";
      hash = "sha256-E0mWvLWQ4lFjkFgqtmMIESpNH7PSAB/QpSqxIwsj6Q8=";
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pythonEnv
    pkg-config
    pnpmConfigHook
    pnpm
    removeReferencesTo
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  # Required for `sharp` npm dependency
  buildInputs = [ vips ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      patchFlags
      patches
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-BTSMmGhLpQ6KrI7/XfinRwe8ap7btIrPa55f6HB63M8=";
  };

  buildPhase = ''
    runHook preBuild

    pushd ./node_modules/.pnpm/better-sqlite3@*/node_modules/better-sqlite3
    npm run build-release --offline --nodedir="${nodeSources}"
    find build -type f -exec remove-references-to -t "${nodeSources}" {} \;
    popd

    makeWrapper "${lib.getExe nodejs}" "$out/bin/pds" \
      --add-flags --enable-source-maps \
      --add-flags "$out/lib/pds/index.ts" \
      --set-default NODE_ENV production

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/pds}
    mv node_modules $out/lib/pds
    mv index.ts $out/lib/pds

    runHook postInstall
  '';

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux { inherit (nixosTests) bluesky-pds; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bluesky Personal Data Server (PDS)";
    homepage = "https://github.com/bluesky-social/pds";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      t4ccer
      isabelroses
    ];
    platforms = lib.platforms.unix;
    mainProgram = "pds";
  };
})
