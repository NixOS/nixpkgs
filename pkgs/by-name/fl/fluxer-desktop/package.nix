{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  electron_40,
  python3,
  autoPatchelfHook,
  cctools,
  libx11,
  libxrandr,
  libxtst,
  libxt,
}:

let
  pnpm = pnpm_10;
  electron = electron_40;
  # must match between Electron metadata name, desktop file and icons
  appId = "app.fluxer.Fluxer";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fluxer-desktop";
  version = "0.0.8-unstable-2026-03-06";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    rootDir = "fluxer_desktop";
    # There are no tagged releases yet, and the version info must be read from the <release> element in
    # fluxer_desktop/packaging/linux/app.fluxer.Fluxer.metainfo.xml
    rev = "03813bbe17db008452f0f1be3090a7d2970a5447";
    hash = "sha256-89gH5NdgVsI62mSHQDZPNi7YCP7qwCDwcipy0TblZmA=";
  };

  patches = [
    # The config seems to target an an older version of electron-builder than
    # listed in its dependencies.
    # See this issue for the incompatibility the patch addresses:
    # https://github.com/electron-userland/electron-builder/issues/9214
    ./electron-builder-config.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-Rh84JplYrd9k4fslofQli4fRNKmFhosftUfYXKBKU4g=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # required by uiohook-napi
    libx11
    libxrandr
    libxtst
    libxt
  ];

  env.NODE_ENV = "production";

  buildPhase = ''
    runHook preBuild

    pnpm build

    # Needs to be writable
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    export npm_config_nodedir=${electron.headers}
    pnpm exec electron-builder \
      --config electron-builder.config.cjs \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.extraMetadata.name=${appId} \
      -c.extraMetadata.version=${finalAttrs.version} \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/{applications,metainfo,${appId}}
    mkdir -p $out/bin

    cp -r ./dist-electron/linux-unpacked/resources/* $out/share/${appId}

    makeWrapper ${lib.getExe electron} $out/bin/fluxer-desktop \
      --add-flags "$out/share/${appId}/app.asar"

    substitute {packaging/linux,$out/share/applications}/${appId}.desktop \
      --replace-fail "Exec=${appId}" "Exec=$out/bin/fluxer-desktop"

    install -Dm444 packaging/linux/${appId}.metainfo.xml $out/share/metainfo/

    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm444 packaging/linux/${appId}.svg $out/share/icons/hicolor/scalable/apps/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{bin,Applications}
    mv dist-electron/mac-*/Fluxer.app $out/Applications/

    # Allow launching the app through a shell (e.g., with `nix run`)
    cat << EOF > "$out/bin/fluxer-desktop"
    #!${stdenv.shell}
    open -na "$out/Applications/Fluxer.app" --args "\$@"
    EOF
    chmod +x "$out/bin/fluxer-desktop"
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    description = "Free and open source instant messaging and VoIP platform built for friends, groups, and communities";
    homepage = "https://fluxer.app/";
    mainProgram = "fluxer-desktop";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
  };
})
