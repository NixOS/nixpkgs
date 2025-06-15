{
  lib,
  stdenv,
  pnpm_10,
  nodejs_24,
  fetchFromGitHub,
  electron_36,
  darwin,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  dart-sass,
  patchelf,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "feishin";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = "feishin";
    rev = "v${version}";
    hash = "sha256-YZWPwMnB3JJ91s0wJGYOwEGMTcRm6UszY4osFX1ChOk=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-xMrf8RgFyYxNQHA8WUuirZwle+tagP5X4+X/DB86ZqU=";
  };

  # https://github.com/sass-contrib/sass-embedded-host-ruby/issues/102
  patches = [ ./0001-build-enable-specifying-custom-sass-compiler-path-by.patch ];

  electron = electron_36;

  makeCacheWritable = true;

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  nativeBuildInputs =
    [
      nodejs_24
      pnpm_10.configHook
      makeWrapper
      electron
      dart-sass
      patchelf
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [ copyDesktopItems ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];

  postPatch =
    ''
      substituteInPlace package.json \
        --replace-fail "electron-builder install-app-deps" ""

      # Don't check for updates.
      substituteInPlace src/main/index.ts \
        --replace-fail "autoUpdater.checkForUpdatesAndNotify();" ""
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # https://github.com/electron/electron/issues/31121
      substituteInPlace src/main/index.ts \
        --replace-fail "process.resourcesPath" "'$out/share/feishin/resources'"
    '';

  buildPhase = ''
    runHook preBuild

    export SASS_EMBEDDED_BIN_PATH="${dart-sass}/bin/sass"
    pnpm --offline electron-vite build

    runHook postBuild
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
      pnpm --offline electron-builder \
      --dir \
      -c.electronDist=${if stdenv.hostPlatform.isDarwin then "./" else electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false
    '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/{Applications,bin}
      cp -r dist/**/Feishin.app $out/Applications/
      makeWrapper $out/Applications/Feishin.app/Contents/MacOS/Feishin $out/bin/feishin
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/feishin
      pushd dist/*/
      cp -r locales resources{,.pak} $out/share/feishin
      popd

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

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapper ${lib.getExe electron} $out/bin/feishin \
      --add-flags $out/share/feishin/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "feishin";
      desktopName = "Feishin";
      comment = "Full-featured Subsonic/Jellyfin compatible desktop music player";
      icon = "feishin";
      exec = "feishin %u";
      categories = [
        "Audio"
        "AudioVideo"
      ];
      mimeTypes = [ "x-scheme-handler/feishin" ];
    })
  ];

  meta = with lib; {
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    homepage = "https://github.com/jeffvli/feishin";
    changelog = "https://github.com/jeffvli/feishin/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "feishin";
    maintainers = with maintainers; [
      onny
      jlbribeiro
    ];
  };
})
