{ lib
, rustPlatform
, fetchFromGitLab
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
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "azymohliad";
    repo = "watchmate";
    rev = "v${version}";
    sha256 = "sha256-HyH+9KMbdiJSmjo2NsAvz8rN3JhYKz1nNqfuZufKjQA=";
  };

  cargoSha256 = "sha256-HvuxKPIVwVrcsTKgPwNosF/ar8QL9Jlldq7SBe2nh6o=";

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
    homepage = "https://gitlab.com/azymohliad/watchmate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
