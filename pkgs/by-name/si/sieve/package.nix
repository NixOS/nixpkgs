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

buildNpmPackage rec {
  pname = "sieve";
  version = "0.6.1-unstable-2024-07-25";

  src = fetchFromGitHub {
    owner = "thsmi";
    repo = pname;
    rev = "5879679ed8d16a34af760ee56bfec16a1a322b4e";
    hash = "sha256-wl6dwKoGan+DrpXk2p1fD/QN/C2qT4h/g3N73gF8sOI=";
  };

  npmDepsHash = "sha256-a2I9csxFZJekG1uCOHqdRaLLi5v/BLTz4SU+uBd855A=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "gulp";
  npmBuildFlags = "app:package";

  nativeBuildInputs =
    lib.optionals stdenv.isLinux [ copyDesktopItems ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild ];

  installPhase = ''
    runHook preInstall

    build_dir=build/electron/resources

    ${lib.optionalString stdenv.isLinux ''
      mkdir -p $out/{share,bin}
      cp -r $build_dir $out/share/sieve

      # copy icon
      icon_dir=$out/share/icons/hicolor/64x64/apps
      mkdir -p $icon_dir
      cp $build_dir/libs/icons/linux.png $icon_dir/sieve.png

      makeWrapper '${lib.getExe electron}' $out/bin/sieve \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}" \
        --add-flags $out/share/sieve
    ''}

    ${lib.optionalString stdenv.isDarwin ''
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

  desktopItems = lib.optionals stdenv.isLinux [
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
    description = "A sieve script editor";
    homepage = "https://github.com/thsmi/sieve";
    license = lib.licenses.agpl3Only;
    mainProgram = "sieve";
    maintainers = with lib.maintainers; [ fugi ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
