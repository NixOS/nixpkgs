{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_39,
  dart-sass,
  mpv,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  darwin,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
let
  pname = "feishin";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = "feishin";
    tag = "v${version}";
    hash = "sha256-PICVNItpMALffpJvQQXLlHcYu1yDtEUclGYjO25f6ew=";
  };

  electron = electron_39;
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
    fetcherVersion = 3;
    hash = "sha256-K9mwEJA0fZXI2OnVo5y4Zmox3mwO8qLvgLiBaoyYAkg=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    pnpm
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ copyDesktopItems ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];

  postPatch = ''
    # release/app dependencies are installed on preConfigure
    substituteInPlace package.json \
      --replace-fail '"postinstall": "electron-builder install-app-deps",' ""
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
    makeWrapper $out/Applications/Feishin.app/Contents/MacOS/Feishin $out/bin/feishin \
      --prefix PATH : "${lib.makeBinPath [ mpv ]}" \
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
      --prefix PATH : "${lib.makeBinPath [ mpv ]}" \
      --add-flags $out/share/feishin/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set DISABLE_AUTO_UPDATES 1 \
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
