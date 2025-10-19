{
  bun,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  git,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  makeWrapper,
}:
let
  name = "notesnook-sync-server";
  version = "1.0-beta.5";
  src = fetchFromGitHub {
    owner = "streetwriters";
    repo = "notesnook-sync-server";
    tag = "v${version}";
    hash = "sha256-92PDPXOv7N/xqXrP87JV4QEOMsmNFCvqksxhsW+y2uU=";
  };

  # Create node_modules as a separate derivation
  node_modules = stdenvNoCC.mkDerivation {
    name = "${name}-node_modules";
    inherit version src;

    sourceRoot = "${src.name}/Notesnook.Inbox.API/";
    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    configurePhase = ''
      runHook preConfigure

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --production

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      bun run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R ./node_modules ./dist $out

      runHook postInstall
    '';

    # Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = "sha256-+4hfccSIBz2tytZMOvE15fN17NQBqpgMg2+gAF4ENus=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
buildDotnetModule {
  inherit name version src;
  executables = [
    "Notesnook.API"
    "Streetwriters.Identity"
    "Streetwriters.Messenger"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  runtimeInputs = [
    bun
  ];

  projectFile = [
    "Notesnook.API/Notesnook.API.csproj"
    "Streetwriters.Data/Streetwriters.Data.csproj"
    "Streetwriters.Identity/Streetwriters.Identity.csproj"
    "Streetwriters.Messenger/Streetwriters.Messenger.csproj"
  ];

  nugetDeps = ./deps.json;

  nativeBuildInputs = [
    git
    makeWrapper
  ];

  preConfigure = ''
    # Copy node_modules from the separate derivation
    cp -R ${node_modules}/node_modules .
  '';

  preInstall = ''
    mkdir -p $out/share/monograph
    pushd Notesnook.Inbox.API
    cp -R ${node_modules}/dist/ package.json $out/share/monograph
    # This wrapper has to be run from the CWD of the $out/share/monograph
    makeWrapper ${lib.getExe bun} '''$out/bin/monograph --add-flags "run start"
    popd
  '';

  doCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Sync server for Notesnook";
    homepage = "https://github.com/streetwriters/notesnook-sync-server";
    mainProgram = "Notesnook.API";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tebriel ];
  };
}
