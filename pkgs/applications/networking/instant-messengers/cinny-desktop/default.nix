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
, webkitgtk
, makeDesktopItem
}:

rustPlatform.buildRustPackage rec {
  pname = "cinny-desktop";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    rev = "v${version}";
    hash = "sha256-RW6LeItIAHJk1e7qMa1MLIGb3jHvJ/KM8E9l1qR48w8=";
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-Iab/icQ9hFVh/o6egZVPa2zeKgO5WxzkluhRckcayvw=";

  postPatch = ''
    substituteInPlace tauri.conf.json \
      --replace '"distDir": "../cinny/dist",' '"distDir": "${cinny}",'
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
    maintainers = [ maintainers.aveltras ];
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    mainProgram = "cinny";
  };
}
