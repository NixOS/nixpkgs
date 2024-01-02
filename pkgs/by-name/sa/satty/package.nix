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
, fetchpatch
, copyDesktopItems
}:

rustPlatform.buildRustPackage rec {

  pname = "satty";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "gabm";
    repo = "Satty";
    rev = "v${version}";
    hash = "sha256-x2ljheG7ZqaeiPersC/e8Er2jvk5TJs65Y3N1GjTiNU=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "fix-Cargo.lock";
      url = "https://github.com/gabm/Satty/commit/39be6ddce264552df971e949a6a3175b102530b2.patch";
      hash = "sha256-GUHupZE1A7AmXvZ8WvRzBkQyH7qlMTetBjHuakfIZ7w=";
    })
  ];

  cargoHash = "sha256-0GsbWd/gpKZm7nNXkuJhB02YKUj3XCrSfpRA9KBXydU=";

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
