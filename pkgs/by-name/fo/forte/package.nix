{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  wrapGAppsHook4,
  imagemagick,
  desktop-file-utils,
  mpv,
  gtk4,
  webkitgtk_6_0,
  nodejs_22,
  ffmpeg,
  writableTmpDirAsHomeHook,
  nix-update-script,
  removeReferencesTo,
  versionCheckHook,
  go,
}:

buildGoModule (
  finalAttrs:
  let
    frontend = buildNpmPackage {
      pname = "forte-frontend";
      inherit (finalAttrs) version;
      src = finalAttrs.src + "/frontend";
      nodejs = nodejs_22;
      npmDepsHash = "sha256-2AQVj9sZNYmOx9Qwln7cg7kzVErKg3nQzvVGqWuWPnA=";
      npmBuildScript = "build";
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r dist/* $out/
        runHook postInstall
      '';
    };
  in
  {
    pname = "forte";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "willfish";
      repo = "forte";
      tag = "v${finalAttrs.version}";
      hash = "sha256-oWJwcQfvYu0cQDT+Br/z6EH3fIRbxw7fACkjUuOfEJ8=";
    };

    __structuredAttrs = true;

    # Linux vendoring applies Wails GTK patches; Darwin vendorHash is separate.
    vendorHash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-1zMhKwEbh5ef9tjDumsX1bsFvrMk2QvaHyTFqDwVc6E="
      else
        "sha256-QlhQms3GnvLVvpQF4r2uEfBOMCCSMtq87PJzo/hmT2k=";

    # Wails vendor tree needs WebView2Loader stubs, and Linux applies GTK patches.
    modBuildPhase = ''
      runHook preBuild

      if [ -d vendor ]; then
        echo "vendor folder exists, please set 'vendorHash = null;' in your expression"
        exit 10
      fi

      export GIT_SSL_CAINFO=$NIX_SSL_CERT_FILE
      go mod download

      # Wails embeds WebView2Loader.dll placeholders that are not present in the
      # module source used by go mod vendor. Stub empty DLLs so embeds resolve.
      mod_cache="$(go env GOMODCACHE)"
      if [ -z "$mod_cache" ]; then
        mod_cache="''${GOPATH:-$HOME/go}/pkg/mod"
      fi
      find "$mod_cache" -type d \( \
        -path '*/wails/webview2@*/webviewloader' -o \
        -path '*/wails/v3@*/internal/webview2/webviewloader' \
      \) 2>/dev/null | while read -r webview2Loader; do
        chmod -R u+w "$(dirname "$webview2Loader")"
        mkdir -p "$webview2Loader/x86" "$webview2Loader/x64" "$webview2Loader/arm64"
        : > "$webview2Loader/x86/WebView2Loader.dll"
        : > "$webview2Loader/x64/WebView2Loader.dll"
        : > "$webview2Loader/arm64/WebView2Loader.dll"
      done

      if (( "''${NIX_DEBUG:-0}" >= 1 )); then
        goModVendorFlags+=(-v)
      fi
      go mod vendor "''${goModVendorFlags[@]}"
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        patch -p1 -d vendor/github.com/wailsapp/wails/v3 < "$src/patches/wails-status-notifier-icon-name.patch"
        patch -p1 -d vendor/github.com/wailsapp/wails/v3 < "$src/patches/wails-gtk4-transparent-window.patch"
      ''}

      mkdir -p vendor
      runHook postBuild
    '';

    tags = [
      "production"
      "nocgo"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "gtk4" ];

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${finalAttrs.version}"
    ];

    subPackages = [ "." ];

    doCheck = true;
    nativeCheckInputs = [
      writableTmpDirAsHomeHook
      ffmpeg
      mpv
    ];
    checkFlags = [
      "-tags=nocgo"
    ];
    # go-mpv (nocgo/purego) dlopens libmpv at package init.
    preCheck = ''
      export LD_LIBRARY_PATH="${lib.makeLibraryPath [ mpv ]}:''${LD_LIBRARY_PATH-}"
    '';

    nativeBuildInputs = [
      pkg-config
      makeWrapper
      removeReferencesTo
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wrapGAppsHook4
      imagemagick
      desktop-file-utils
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      imagemagick
    ];

    buildInputs = [
      mpv
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gtk4
      webkitgtk_6_0
    ];

    preBuild = ''
      rm -rf frontend/dist
      mkdir -p frontend/dist
      cp -r ${frontend}/* frontend/dist/
    '';

    postInstall = ''
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        for size in 16 24 32 48 64 128 256 512; do
          install -d "$out/share/icons/hicolor/''${size}x''${size}/apps"
          magick build/appicon.png -resize "''${size}x''${size}" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/io.github.willfish.forte.png"
          cp "$out/share/icons/hicolor/''${size}x''${size}/apps/io.github.willfish.forte.png" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/forte.png"
        done
        install -Dm644 build/logo.svg $out/share/icons/hicolor/scalable/apps/io.github.willfish.forte.svg
        install -Dm644 build/logo.svg $out/share/icons/hicolor/scalable/apps/forte.svg
        install -Dm644 build/tray-idle.svg $out/share/icons/hicolor/scalable/apps/io.github.willfish.forte-tray-idle.svg
        install -Dm644 build/tray-playing.svg $out/share/icons/hicolor/scalable/apps/io.github.willfish.forte-tray-playing.svg
        for size in 16 24 32 48; do
          install -Dm644 "build/tray-idle-''${size}.png" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/io.github.willfish.forte-tray-idle.png"
          install -Dm644 "build/tray-playing-''${size}.png" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/io.github.willfish.forte-tray-playing.png"
        done
        for theme in green-dark green-light blue-dark blue-light financial-times-dark financial-times-light; do
          install -Dm644 "build/tray-''${theme}-idle-32.png" \
            "$out/share/icons/hicolor/32x32/apps/io.github.willfish.forte-tray-''${theme}-idle.png"
          install -Dm644 "build/tray-''${theme}-playing-32.png" \
            "$out/share/icons/hicolor/32x32/apps/io.github.willfish.forte-tray-''${theme}-playing.png"
        done
        install -Dm644 build/appicon.png $out/share/pixmaps/forte.png
        install -Dm644 build/linux/forte.desktop $out/share/applications/io.github.willfish.forte.desktop
        desktop-file-validate $out/share/applications/io.github.willfish.forte.desktop
      ''}

      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        appDir="$out/Applications/Forte.app"
        mkdir -p "$appDir/Contents"/{MacOS,Resources}
        cp build/appicon.png "$appDir/Contents/Resources/appicon.png"
        mkdir -p "$appDir/Contents/Resources/icon.iconset"
        for s in 16 32 128 256 512; do
          magick build/appicon.png -resize "''${s}x''${s}" -background none \
            "$appDir/Contents/Resources/icon.iconset/icon_''${s}x''${s}.png"
          magick build/appicon.png -resize "''${s}x''${s}" -background none \
            "$appDir/Contents/Resources/icon.iconset/icon_''${s}x''${s}@2x.png"
        done
        cat > "$appDir/Contents/Info.plist" <<PLIST
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>CFBundleDevelopmentRegion</key>
          <string>en</string>
          <key>CFBundleExecutable</key>
          <string>forte</string>
          <key>CFBundleIconFile</key>
          <string>appicon</string>
          <key>CFBundleIdentifier</key>
          <string>io.github.willfish.forte</string>
          <key>CFBundleInfoDictionaryVersion</key>
          <string>6.0</string>
          <key>CFBundleName</key>
          <string>Forte</string>
          <key>CFBundlePackageType</key>
          <string>APPL</string>
          <key>CFBundleShortVersionString</key>
          <string>${finalAttrs.version}</string>
          <key>CFBundleVersion</key>
          <string>${finalAttrs.version}</string>
          <key>LSMinimumSystemVersion</key>
          <string>10.13</string>
          <key>NSHighResolutionCapable</key>
          <true/>
        </dict>
        </plist>
        PLIST
        cp $out/bin/forte "$appDir/Contents/MacOS/forte-bin"
        chmod +x "$appDir/Contents/MacOS/forte-bin"
        makeWrapper "$appDir/Contents/MacOS/forte-bin" "$appDir/Contents/MacOS/forte" \
          --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ mpv ]}"
        rm -f $out/bin/forte || true
        makeWrapper "$appDir/Contents/MacOS/forte" "$out/bin/forte" \
          --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ mpv ]}"
      ''}
    '';

    preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ mpv ]}"
      )
    '';

    # modernc/sqlite and similar embed toolchain paths; nixpkgs forbids Go in $out.
    postFixup = ''
      find "$out" -type f -exec remove-references-to -t ${go} '{}' +
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    passthru = {
      inherit frontend;
      updateScript = nix-update-script { };
    };

    meta = {
      description = "Play internet radio and local or streaming music libraries";
      longDescription = ''
        Forte is a desktop music player. It plays internet radio out of the box
        and can optionally manage a local music library plus Subsonic and
        Jellyfin servers in the same collection. Playback is built on mpv.
      '';
      homepage = "https://github.com/willfish/forte";
      changelog = "https://github.com/willfish/forte/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ willfish ];
      mainProgram = "forte";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
)
