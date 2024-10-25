{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  cacert,
  gitMinimal,
  nodejs,
  yarn,
  nixosTests,
}:
let
  version = "24.10.1";
  src = fetchFromGitHub {
    owner = "actualbudget";
    repo = "actual-server";
    rev = "v${version}";
    hash = "sha256-VJAD+lNamwuYmiPJLXkum6piGi5zLOHBp8cUeZagb4s=";
  };

  # We cannot use fetchYarnDeps because that doesn't support yarn2/berry
  # lockfiles (see https://github.com/NixOS/nixpkgs/issues/254369)
  offlineCache = stdenvNoCC.mkDerivation {
    name = "actual-server-${version}-offline-cache";
    inherit src;

    nativeBuildInputs = [
      cacert # needed for git
      gitMinimal # needed to download git dependencies
      yarn
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
    outputHash = "sha256-eNpOS21pkamugoYVhzsEnstxeVN/J06yDZcshfr0Ek4=";
  };
in
stdenv.mkDerivation {
  pname = "actual-server";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
    yarn
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,lib/actual}
    cp -r ${offlineCache}/node_modules/ $out/lib/actual
    cp -r ./ $out/lib/actual

    makeWrapper ${lib.getExe nodejs} "$out/bin/actual-server" \
      --add-flags "$out/lib/actual/app.js" \
      --set NODE_PATH "$out/node_modules"

    runHook postInstall
  '';

  passthru = {
    inherit offlineCache;
    tests = nixosTests.actual;
  };

  meta = {
    description = "A super fast privacy-focused app for managing your finances";
    homepage = "https://actualbudget.org/";
    mainProgram = "actual-server";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.oddlama
      lib.maintainers.patrickdag
    ];
  };
}
