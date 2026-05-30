{
  stdenv,
  electron,
  nodejs-slim,
  fetchFromGitHub,
  fetchYarnDeps,
  node-gyp,
  lib,
  makeWrapper,

  yarnConfigHook,
  yarnBuildHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "steam-rom-manager";
  version = "2.5.34";
  src = fetchFromGitHub {
    owner = "SteamGridDB";
    repo = "steam-rom-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8qPOYV1aPywC5xvPV4y1boLwiBzIZtp3ekbl54FofbE=";
  };
  patches = [
    ./update-deps.patch
    ./fix-tsc-errors.patch
  ];
  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src patches;
    hash = "sha256-KDN8RUjNJ2gLmuE7R0lag5bSJs6V2NOETQDHbgGDiOs=";
  };
  nativeBuildInputs = [
    nodejs-slim
    nodejs-slim.npm
    nodejs-slim.python
    node-gyp
    yarnConfigHook
    yarnBuildHook
    makeWrapper
  ];
  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_nodedir = electron.headers;
  };

  preBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    yarn run --offline prepare:build
    yarn run --offline build:main
    yarn run --offline build:renderer
  '';
  yarnBuildScript = "electron-builder";
  yarnBuildFlags = [
    "-c.electronDist=electron-dist"
    "-c.electronVersion=${electron.version}"
    "--dir"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [ "--x64" ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "--arm64" ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "--linux" ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--mac" ]
  ++ lib.optionals stdenv.hostPlatform.isWindows [ "--win" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/steam-rom-manager
    cp -r release/*-unpacked/{locales,resources{,.pak}} $out/share/steam-rom-manager

    makeWrapper ${lib.getExe electron} $out/bin/steam-rom-manager \
        --add-flags $out/share/steam-rom-manager/resources/app.asar \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --inherit-argv0

    runHook postInstall
  '';

  meta = {
    description = "App for managing ROMs in Steam";
    homepage = "https://github.com/SteamGridDB/steam-rom-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ squarepear ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "steam-rom-manager";
  };
})
