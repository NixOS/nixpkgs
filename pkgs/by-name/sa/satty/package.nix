{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, cairo
, gdk-pixbuf
, glib
, gtk4
, libadwaita
, pango
, copyDesktopItems
}:

rustPlatform.buildRustPackage rec {

  pname = "satty";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "gabm";
    repo = "Satty";
    rev = "v${version}";
    hash = "sha256-KCHKR6DP8scd9xdWi0bLw3wObrEi0tOsflXHa9f4Z5k=";
  };

  cargoHash = "sha256-pUBtUC+WOuiypLUpXCPR1pu0fRrMVTxg7FE2JSaszNw=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
  ];

  postInstall = ''
    install -Dt $out/share/icons/hicolor/scalable/apps/ assets/satty.svg
  '';

  desktopItems = [ "satty.desktop" ];

  meta = with lib; {
    description = "A screenshot annotation tool inspired by Swappy and Flameshot";
    homepage = "https://github.com/gabm/Satty";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "satty";
    platforms = lib.platforms.linux;
  };
}
