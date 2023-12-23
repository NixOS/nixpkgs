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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "gabm";
    repo = "Satty";
    rev = "v${version}";
    hash = "sha256-5FKEQUH43qx8w7s7lW8EDOWtWCUJTbWlXcMQazR8Thk=";
  };

  cargoHash = "sha256-FpCmzU2C+5+5eSB5Mno+lOFd4trHXmfp6e5oV+CvU1c=";

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
