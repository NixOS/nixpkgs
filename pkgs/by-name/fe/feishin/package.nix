{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_41,
  dart-sass,
  mpv-unwrapped,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  darwin,
  actool,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
let
  pname = "feishin";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = "feishin";
    tag = "v${version}";
    hash = "sha256-v6dWzEB1+IK4bHmDo8Rr5e0Xi3OWKcm+UPBmBiSfdZ0=";
  };

  electron = electron_41;
in
buildNpmPackage {
  inherit pname version;

  inherit src;

  npmConfigHook = pnpmConfigHook;

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-zNOGJ24G0xcgsGK4DmbBm7d1PHTp7IJS+RTALGRtfDg=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    pnpm_10
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ copyDesktopItems ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
    actool
  ];

  postPatch = ''
    # release/app dependencies are installed on preConfigure
    substituteInPlace package.json \
      --replace-fail '"postinstall": "electron-builder install-app-deps",' ""
  '';

  preBuild = ''
    rm -r node_modules/.pnpm/sass-embedded-*

    test -d node_modules/.pnpm/sass-embedded@*
    dir="$(echo node_modules/.pnpm/sass-embedded@*)/node_modules/sass-embedded/dist/lib/src/vendor/dart-sass"
    mkdir -p "$dir"
    ln -s ${dart-sass}/bin/dart-sass "$dir"/sass
  '';

  postBuild = ''
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
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -r dist/**/Feishin.app $out/Applications/
    makeWrapper $out/Applications/Feishin.app/Contents/MacOS/Feishin $out/bin/feishin \
      --prefix PATH : "${lib.makeBinPath [ mpv-unwrapped ]}" \
      --set DISABLE_AUTO_UPDATES 1
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
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

  desktopItems = [
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
    mainProgram = "feishin";
    maintainers = with lib.maintainers; [
      BatteredBunny
      onny
      jlbribeiro
    ];
  };
}
