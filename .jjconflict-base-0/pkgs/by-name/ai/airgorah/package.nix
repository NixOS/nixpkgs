{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  glib,
  pango,
  gdk-pixbuf,
  graphene,
  gtk4,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "airgorah";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "martin-olivier";
    repo = "airgorah";
    rev = "refs/tags/v${version}";
    hash = "sha256-cIb40TKkk3gfy4dTP8WyZqQkRGj5nItaQ3NSfexCUOA=";
  };

  cargoHash = "sha256-sJFOpxBW6Z8ewfyhJuxZByJNgaEmezw15OQt9KjFaec=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    pango
    gdk-pixbuf
    graphene
    gtk4
  ];

  postInstall = ''
    install -Dm644 icons/app_icon.png $out/share/icons/hicolor/1024x1024/apps/airgorah.png
  '';

  dessktopItems = [
    (makeDesktopItem {
      name = "airgorah";
      comment = "A WiFi auditing software that can perform deauth attacks and passwords cracking";
      desktopName = "airgorah";
      exec = "pkexec airgorah";
      icon = "airgorah";
      categories = [
        "Network"
        "Monitor"
        "Utility"
        "GTK"
      ];
      type = "Application";
      terminal = false;
    })
  ];

  meta = {
    description = "WiFi security auditing software mainly based on aircrack-ng tools suite";
    homepage = "https://github.com/martin-olivier/airgorah";
    changelog = "https://github.com/martin-olivier/airgorah/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "airgorah";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.linux;
  };
}
