{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_38,
  dart-sass,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
=======
  pnpm_10,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  darwin,
  copyDesktopItems,
  makeDesktopItem,
}:
let
  pname = "feishin";
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "0.21.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = "feishin";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-otobV3bpANbhrAiscDxV1IGJ36i/37aPei6wdo5SDSw=";
  };

  electron = electron_38;
=======
    hash = "sha256-F5m0hsN1BLfiUcl2Go54bpFnN8ktn6Rqa/df1xxoCA4=";
  };

  electron = electron_38;
  pnpm = pnpm_10;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildNpmPackage {
  inherit pname version;

  inherit src;

<<<<<<< HEAD
  npmConfigHook = pnpmConfigHook;

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
=======
  npmConfigHook = pnpm.configHook;

  npmDeps = null;
  pnpmDeps = pnpm.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit
      pname
      version
      src
      ;
    fetcherVersion = 2;
<<<<<<< HEAD
    hash = "sha256-iZs2YtB0U8RpZXrIYHBc/cgFISDF/4tz+D13/+HlszU=";
=======
    hash = "sha256-5jEXdQMZ6a0JuhjPS1eZOIGsIGQHd6nKPI02eeR35pg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

<<<<<<< HEAD
  nativeBuildInputs = [
    pnpm
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ copyDesktopItems ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];
=======
  nativeBuildInputs =
    lib.optionals (stdenv.hostPlatform.isLinux) [ copyDesktopItems ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postPatch = ''
    # release/app dependencies are installed on preConfigure
    substituteInPlace package.json \
      --replace-fail '"postinstall": "electron-builder install-app-deps",' ""
<<<<<<< HEAD
=======

    # Don't check for updates.
    substituteInPlace src/main/index.ts \
      --replace-fail "autoUpdater.checkForUpdatesAndNotify();" ""
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # https://github.com/electron/electron/issues/31121
    substituteInPlace src/main/index.ts \
      --replace-fail "process.resourcesPath" "'$out/share/feishin/resources'"
  '';

  preBuild = ''
    rm -r node_modules/.pnpm/sass-embedded-*

    test -d node_modules/.pnpm/sass-embedded@*
    dir="$(echo node_modules/.pnpm/sass-embedded@*)/node_modules/sass-embedded/dist/lib/src/vendor/dart-sass"
    mkdir -p "$dir"
    ln -s ${dart-sass}/bin/dart-sass "$dir"/sass
  '';

  postBuild =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      # electron-builder appears to build directly on top of Electron.app, by overwriting the files in the bundle.
      cp -r ${electron.dist}/Electron.app ./
      find ./Electron.app -name 'Info.plist' | xargs -d '\n' chmod +rw

      # Disable code signing during build on macOS.
      # https://github.com/electron-userland/electron-builder/blob/fa6fc16/docs/code-signing.md#how-to-disable-code-signing-during-the-build-process-on-macos
      export CSC_IDENTITY_AUTO_DISCOVERY=false
      sed -i "/afterSign/d" package.json
    ''
    + ''
      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${if stdenv.hostPlatform.isDarwin then "./" else electron.dist} \
        -c.electronVersion=${electron.version} \
        -c.npmRebuild=false
    '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -r dist/**/Feishin.app $out/Applications/
<<<<<<< HEAD
    makeWrapper $out/Applications/Feishin.app/Contents/MacOS/Feishin $out/bin/feishin \
      --set DISABLE_AUTO_UPDATES 1
=======
    makeWrapper $out/Applications/Feishin.app/Contents/MacOS/Feishin $out/bin/feishin
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
      --add-flags $out/share/feishin/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
<<<<<<< HEAD
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set DISABLE_AUTO_UPDATES 1 \
=======
      --set ELECTRON_FORCE_IS_PACKAGED=1 \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      --inherit-argv0

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
<<<<<<< HEAD
      comment = "Full-featured Jellyfin, Navidrome, and OpenSubsonic Compatible Music Player";
=======
      comment = "Full-featured Subsonic/Jellyfin compatible desktop music player";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      icon = "feishin";
      exec = "feishin %u";
      categories = [
        "Audio"
        "AudioVideo"
<<<<<<< HEAD
        "Player"
        "Music"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      ];
      mimeTypes = [ "x-scheme-handler/feishin" ];
    })
  ];

  meta = {
<<<<<<< HEAD
    description = "Full-featured Jellyfin, Navidrome, and OpenSubsonic Compatible Music Player";
=======
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/jeffvli/feishin";
    changelog = "https://github.com/jeffvli/feishin/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "feishin";
    maintainers = with lib.maintainers; [
<<<<<<< HEAD
      BatteredBunny
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      onny
      jlbribeiro
    ];
  };
}
