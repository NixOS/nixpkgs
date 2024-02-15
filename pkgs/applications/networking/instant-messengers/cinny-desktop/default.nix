{ lib
, fetchFromGitHub
, rustPlatform
, cinny
, copyDesktopItems
, wrapGAppsHook
, pkg-config
, openssl
, dbus
, glib
, glib-networking
, libayatana-appindicator
, webkitgtk
, makeDesktopItem
}:

rustPlatform.buildRustPackage rec {
  pname = "cinny-desktop";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    rev = "v${version}";
    hash = "sha256-v5D0/EHVQ2xo7TGo+jZoRDBVFczkaZu2ka6QpwV4dpw=";
  };

  sourceRoot = "${src.name}/src-tauri";

  # modififying $cargoDepsCopy requires the lock to be vendored
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = let
    cinny' =
      assert lib.assertMsg (cinny.version == version) "cinny.version (${cinny.version}) != cinny-desktop.version (${version})";
      cinny;
  in ''
    substituteInPlace tauri.conf.json \
      --replace '"distDir": "../cinny/dist",' '"distDir": "${cinny'}",'

    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  postInstall = ''
    install -DT icons/128x128@2x.png $out/share/icons/hicolor/256x256@2/apps/cinny.png
    install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/cinny.png
    install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/cinny.png
  '';

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
    glib
    glib-networking
    libayatana-appindicator
    webkitgtk
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "cinny";
      exec = "cinny";
      icon = "cinny";
      desktopName = "Cinny";
      comment = meta.description;
      categories = [ "Network" "InstantMessaging" ];
    })
  ];

  meta = with lib; {
    description = "Yet another matrix client for desktop";
    homepage = "https://github.com/cinnyapp/cinny-desktop";
    maintainers = [ ];
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    mainProgram = "cinny";
  };
}
