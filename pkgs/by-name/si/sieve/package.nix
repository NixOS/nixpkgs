{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  stdenv,
  xcbuild,
}:

buildNpmPackage {
  pname = "sieve";
  version = "0.6.1-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "thsmi";
    repo = "sieve";
    rev = "a9f2e682fd972bd0e12bde3dac7d2a1516f66456";
    hash = "sha256-PL17gh+nS90Y9Rli7XCoHOjl0NJOxko79ouYzLeou6Y=";
  };

  npmDepsHash = "sha256-66VnbYe6j7i6sxKQ/RHzGlFoNLig9yBTXby6meN0nOE=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "gulp";
  npmBuildFlags = "app:package";

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  installPhase = ''
    runHook preInstall

    build_dir=build/electron/resources

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/{share,bin}
      cp -r $build_dir $out/share/sieve

      # copy icon
      install -D $build_dir/libs/icons/linux.png $out/share/icons/hicolor/64x64/apps/sieve.png

      makeWrapper '${lib.getExe electron}' $out/bin/sieve \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}" \
        --add-flags $out/share/sieve
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      app_dir=$out/Applications/Sieve.app

      # copy electron
      mkdir -p $out/Applications
      cp -r ${electron}/Applications/Electron.app $app_dir
      chmod -R +w $app_dir
      mv $app_dir/Contents/MacOS/{Electron,Sieve}

      # copy built app
      cp -r $build_dir $app_dir/Contents/Resources/app
      cp $app_dir/Contents/Resources/{app/libs/icons/mac.icns,sieve.icns}

      # rebranding
      info_plist="$app_dir/Contents/Info.plist"
      plutil -replace CFBundleDisplayName -string Sieve "$info_plist"
      plutil -replace CFBundleIdentifier -string net.tschmid.sieve "$info_plist"
      plutil -replace CFBundleName -string Sieve "$info_plist"
      plutil -replace CFBundleExecutable -string Sieve "$info_plist"
      plutil -replace CFBundleIconFile -string sieve.icns "$info_plist"

      # add wrapper for main executable
      mkdir -p $out/bin
      makeWrapper $app_dir/Contents/MacOS/Sieve $out/bin/sieve
    ''}

    runHook postInstall
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "sieve";
      exec = "sieve";
      desktopName = "Sieve";
      icon = "sieve";
      comment = "Sieve script editor";
      categories = [
        "Network"
        "Email"
      ];
    })
  ];

  meta = {
    description = "Sieve script editor";
    homepage = "https://github.com/thsmi/sieve";
    license = lib.licenses.agpl3Only;
    mainProgram = "sieve";
    maintainers = with lib.maintainers; [ fugi ];
    inherit (electron.meta) platforms;
  };
}
