{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_41,
  mpv-unwrapped,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs-slim_latest,
  darwin,
  actool,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  webVersion ? false,
}:
let
  pname = "feishin";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = "feishin";
    tag = "v${version}";
    hash = "sha256-2UKJBUZNUpUUZIG1JFXok7YJdzqt+Ge0ykHUm8BeNcw=";
  };

  electron = electron_41;

  # Fix pnpm issue on darwin https://github.com/NixOS/nixpkgs/issues/525627
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_latest; };
in
buildNpmPackage {
  inherit pname version;

  inherit src;

  __structuredAttrs = true;

  npmConfigHook = pnpmConfigHook;
  npmBuildScript = if webVersion then "build:web" else "build";

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      pnpm
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-9uG0AxIBAmuIPywg3p9fFCXmRvM9zDLhWfluSLRnUXY=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    pnpm
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && !webVersion) [ copyDesktopItems ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && !webVersion) [
    darwin.autoSignDarwinBinariesHook
    actool
  ];

  postPatch = ''
    # release/app dependencies are installed on preConfigure
    substituteInPlace package.json \
      --replace-fail '"postinstall": "electron-builder install-app-deps",' ""
  '';

  postBuild = lib.optionalString (!webVersion) ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"}
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString webVersion ''
    mkdir -p $out
    cp -r out/web/* $out
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && !webVersion) ''
    mkdir -p $out/{Applications,bin}
    cp -r dist/**/Feishin.app $out/Applications/
    makeWrapper $out/Applications/Feishin.app/Contents/MacOS/Feishin $out/bin/feishin \
      --prefix PATH : "${lib.makeBinPath [ mpv-unwrapped ]}" \
      --set DISABLE_AUTO_UPDATES 1
  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux && !webVersion) ''
    mkdir -p $out/share/feishin

    pushd dist/*-unpacked/
    cp -r locales resources{,.pak} $out/share/feishin
    popd

    # Code relies on checking app.isPackaged, which returns false if the executable is electron.
    # Set ELECTRON_FORCE_IS_PACKAGED=1.
    # https://github.com/electron/electron/issues/35153#issuecomment-1202718531
    makeWrapper ${lib.getExe electron} $out/bin/feishin \
      --prefix PATH : "${lib.makeBinPath [ mpv-unwrapped ]}" \
      --add-flags $out/share/feishin/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set DISABLE_AUTO_UPDATES 1 \
      --inherit-argv0

    install -Dm644 org.jeffvli.feishin.metainfo.xml $out/share/metainfo/org.jeffvli.feishin.metainfo.xml

    for size in 32 64 128 256 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      ln -s \
        $out/share/feishin/resources/assets/icons/"$size"x"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/feishin.png
    done
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optionals (!webVersion) [
    (makeDesktopItem {
      name = "feishin";
      desktopName = "Feishin";
      comment = "Full-featured Jellyfin, Navidrome, and OpenSubsonic Compatible Music Player";
      icon = "feishin";
      exec = "feishin %u";
      categories = [
        "Audio"
        "AudioVideo"
        "Player"
        "Music"
      ];
      mimeTypes = [ "x-scheme-handler/feishin" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full-featured Jellyfin, Navidrome, and OpenSubsonic Compatible Music Player";
    homepage = "https://github.com/jeffvli/feishin";
    changelog = "https://github.com/jeffvli/feishin/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      BatteredBunny
      onny
      jlbribeiro
    ];
  }
  // lib.optionalAttrs (!webVersion) { mainProgram = "feishin"; };
}
