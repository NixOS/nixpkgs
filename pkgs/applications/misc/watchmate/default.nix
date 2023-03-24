{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk4
, libadwaita
, bluez
, dbus
, openssl
, wrapGAppsHook4
, glib
}:

rustPlatform.buildRustPackage rec {
  pname = "watchmate";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "azymohliad";
    repo = "watchmate";
    rev = "v${version}";
    hash = "sha256-+E1tyDfFSu3J89fXd75bdYxh+Z1zTwKL6AmMTNQBEYY=";
  };

  cargoHash = "sha256-xfgO2MInUAidgqN1B7byMIzHD19IzbnBvRMo7Ir10hk=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib
  ];
  buildInputs = [
    gtk4
    libadwaita
    bluez
    dbus
    openssl
  ];

  postInstall = ''
    install -Dm444 assets/io.gitlab.azymohliad.WatchMate.desktop -t $out/share/applications/
    install -Dm444 assets/io.gitlab.azymohliad.WatchMate.metainfo.xml -t $out/share/metainfo/
    install -Dm444 assets/icons/io.gitlab.azymohliad.WatchMate.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 assets/icons/io.gitlab.azymohliad.WatchMate-symbolic.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  meta = with lib; {
    description = "PineTime smart watch companion app for Linux phone and desktop";
    homepage = "https://github.com/azymohliad/watchmate";
    changelog = "https://github.com/azymohliad/watchmate/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
