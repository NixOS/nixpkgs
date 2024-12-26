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
  version = "24.12.0";
  src = fetchFromGitHub {
    owner = "actualbudget";
    repo = "actual-server";
    tag = "v${version}";
    hash = "sha256-qCATfpYjDlR2LaalkF0/b5tD4HDE4aNDrLvTC4g0ctY=";
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
      yarn

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
        x86_64-linux = "sha256-Rz+iKw4JDWtZOrCjs9sbHVw/bErAEY4TfoG+QfGKY94=";
        aarch64-linux = "sha256-JGpRoIQrEI6crczHD62ZQO08GshBbzJC0dONYD69K/I=";
        aarch64-darwin = "sha256-v2qzKmtqBdU6igyHat+NyL/XTzWgq/CKlNpai/iFHyQ=";
        x86_64-darwin = "sha256-0ksWLlF/a58KY/8NgOQ5aPOLoXzqDqO3lhkmFvT17Bk=";
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

    mkdir -p $out/{bin,lib,lib/actual}
    cp -r ${offlineCache}/node_modules/ $out/lib/actual
    cp -r ./ $out/lib/actual

    makeWrapper ${lib.getExe nodejs_20} "$out/bin/actual-server" \
      --add-flags "$out/lib/actual/app.js" \
      --set NODE_PATH "$out/node_modules"

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
