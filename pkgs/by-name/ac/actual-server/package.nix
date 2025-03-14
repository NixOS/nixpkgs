{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  cacert,
  gitMinimal,
  nodejs_20,
  yarn,
  nixosTests,
  nix-update-script,
}:
let
  version = "25.3.1";
  src = fetchFromGitHub {
    owner = "actualbudget";
    repo = "actual";
    tag = "v${version}";
    hash = "sha256-UZ2Z1tkMbGJwka//cIC0aG1KCcTSxUPLzctEaOhnKQA=";
  };

  yarn_20 = yarn.override { nodejs = nodejs_20; };

  # We cannot use fetchYarnDeps because that doesn't support yarn2/berry
  # lockfiles (see https://github.com/NixOS/nixpkgs/issues/254369)
  offlineCache = stdenvNoCC.mkDerivation {
    name = "actual-server-${version}-offline-cache";
    inherit src;

    nativeBuildInputs = [
      cacert # needed for git
      gitMinimal # needed to download git dependencies
      yarn_20
    ];

    SUPPORTED_ARCHITECTURES = builtins.toJSON {
      os = [
        "darwin"
        "linux"
      ];
      cpu = [
        "arm"
        "arm64"
        "ia32"
        "x64"
      ];
      libc = [
        "glibc"
        "musl"
      ];
    };

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      yarn config set enableTelemetry 0
      yarn config set cacheFolder $out
      yarn config set --json supportedArchitectures "$SUPPORTED_ARCHITECTURES"

      yarn workspaces focus @actual-app/sync-server --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./node_modules $out/node_modules

      runHook postInstall
    '';
    dontFixup = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash =
      {
        aarch64-darwin = "sha256-IJBfBA71PZeE/Zlu2kzQw8l/D4lVAV5I5loRyRfncKA=";
        aarch64-linux = "sha256-djE2lt/o/7kd7ci2TW3mhjSptD3etChbvtdbiWqp/wo=";
        x86_64-darwin = "sha256-AShd87VFwqDbJZoFJPg6HsdhTx7XMVdZ5sRWLXU8ldM=";
        x86_64-linux = "sha256-me0v+RuoleOKFRyJ7iyLTKRnV2Cz2Q1MLc/SE2sSSH8=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };
in
stdenv.mkDerivation {
  pname = "actual-server";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
    yarn_20
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,lib/actual/packages/sync-server}
    cp -r ${offlineCache}/node_modules/ $out/lib/actual
    cp -r ./packages/sync-server/{app.js,src,migrations,package.json} $out/lib/actual/packages/sync-server

    makeWrapper ${lib.getExe nodejs_20} "$out/bin/actual-server" \
      --add-flags "$out/lib/actual/packages/sync-server/app.js" \
      --set NODE_PATH "$out/actual/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    inherit offlineCache;
    tests = nixosTests.actual;
    passthru.updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://actualbudget.org/docs/releases";
    description = "Super fast privacy-focused app for managing your finances";
    homepage = "https://actualbudget.org/";
    mainProgram = "actual-server";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.oddlama
      lib.maintainers.patrickdag
    ];
  };
}
