{
  lib,
  aircrack-ng,
  copyDesktopItems,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  graphene,
  gtk4,
  iw,
  macchanger,
  makeDesktopItem,
  pango,
  pkg-config,
  rustPlatform,
  wireshark-cli,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "airgorah";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "martin-olivier";
    repo = "airgorah";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gRQ596NhvOmsGscYsl4o+bhPbanx5kFOJnEeXPTVJEY=";
  };

  cargoHash = "sha256-y9akyXjNHaqSJIvFOiYbg+AygSV9KTWJ2pBlgGaJFOs=";

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
    install -Dm644 crates/gui/icons/app_icon.png $out/share/icons/airgorah.png
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        iw
        aircrack-ng
        wireshark-cli
        macchanger
      ]
    })
  '';

  desktopItems = [
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
    changelog = "https://github.com/martin-olivier/airgorah/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "airgorah";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.linux;
  };
})
