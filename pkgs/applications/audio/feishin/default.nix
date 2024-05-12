{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_27,
  darwin,
  copyDesktopItems,
  makeDesktopItem,
  ...
}:
let
  pname = "feishin";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eNGHrSF/MgRHh0CVc0l8denZIbAnPXwFCZJZcvF+Xtc=";
  };

  electron = electron_27;
in
buildNpmPackage {
  inherit pname version;

  inherit src;
  npmDepsHash = "sha256-7oh5bl5APAvzb/TxHMUP/saRWLwuP9xqGvn7/RDhFk8=";

  npmFlags = [ "--legacy-peer-deps" ];
  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs =
    lib.optionals (stdenv.isLinux) [ copyDesktopItems ]
    ++ lib.optionals stdenv.isDarwin [ darwin.autoSignDarwinBinariesHook ];

  postPatch =
    ''
      # release/app dependencies are installed on preConfigure
      substituteInPlace package.json \
        --replace-fail "electron-builder install-app-deps &&" ""

      # Don't check for updates.
      substituteInPlace src/main/main.ts \
        --replace-fail "autoUpdater.checkForUpdatesAndNotify();" ""
    ''
    + lib.optionalString stdenv.isLinux ''
      # https://github.com/electron/electron/issues/31121
      substituteInPlace src/main/main.ts \
        --replace-fail "process.resourcesPath" "'$out/share/feishin/resources'"
    '';

  preConfigure =
    let
      releaseAppDeps = buildNpmPackage {
        pname = "${pname}-release-app";
        inherit version;

        src = "${src}/release/app";
        npmDepsHash = "sha256-NgWPr3mctn7f6X2JFsbdNNHkN84RRlLAywqfbyahCQw=";

        npmFlags = [ "--ignore-scripts" ];
        dontNpmBuild = true;

        env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
      };
      releaseNodeModules = "${releaseAppDeps}/lib/node_modules/feishin/node_modules";
    in
    ''
      for release_module_path in "${releaseNodeModules}"/*; do
        rm -rf node_modules/"$(basename "$release_module_path")"
        ln -s "$release_module_path" node_modules/
      done
    '';

  postBuild =
    lib.optionalString stdenv.isDarwin ''
      # electron-builder appears to build directly on top of Electron.app, by overwriting the files in the bundle.
      cp -r ${electron}/Applications/Electron.app ./
      find ./Electron.app -name 'Info.plist' | xargs -d '\n' chmod +rw

      # Disable code signing during build on macOS.
      # https://github.com/electron-userland/electron-builder/blob/fa6fc16/docs/code-signing.md#how-to-disable-code-signing-during-the-build-process-on-macos
      export CSC_IDENTITY_AUTO_DISCOVERY=false
      sed -i "/afterSign/d" package.json
    ''
    + ''
      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${if stdenv.isDarwin then "./" else "${electron}/libexec/electron"} \
        -c.electronVersion=${electron.version} \
        -c.npmRebuild=false
    '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/{Applications,bin}
      cp -r release/build/**/Feishin.app $out/Applications/
      makeWrapper $out/Applications/Feishin.app/Contents/MacOS/Feishin $out/bin/feishin
    ''
    + lib.optionalString stdenv.isLinux ''
      mkdir -p $out/share/feishin
      pushd release/build/*/
      cp -r locales resources{,.pak} $out/share/feishin
      popd

      # Code relies on checking app.isPackaged, which returns false if the executable is electron.
      # Set ELECTRON_FORCE_IS_PACKAGED=1.
      # https://github.com/electron/electron/issues/35153#issuecomment-1202718531
      makeWrapper ${lib.getExe electron} $out/bin/feishin \
        --add-flags $out/share/feishin/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set ELECTRON_FORCE_IS_PACKAGED=1 \
        --inherit-argv0

      for size in 32 64 128 256 512 1024; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        ln -s \
          $out/share/feishin/resources/assets/icons/"$size"x"$size".png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
      done
    ''
    + ''
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "feishin";
      desktopName = "Feishin";
      comment = "Full-featured Subsonic/Jellyfin compatible desktop music player";
      icon = pname;
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
}
