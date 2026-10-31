{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
  webkitgtk_4_1,
  gtk3,
  gst_all_1,
  enchant,
  libayatana-appindicator,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rin-chat";
  version = "0.9.0";

  src = fetchurl {
    url = "https://rin.chat/updates/RinChat_${finalAttrs.version}_amd64.deb";
    sha256 = "sha256-PvYMWGNfDLO2Ya3fQc4SQ4hKHtK/pG5rGEHtjMt2nUw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    webkitgtk_4_1 # Verified dependence
    gtk3 # Upstream dev claims dependence
    enchant # Upstream dev claims dependence (spellcheck)
    # Upstream dev claims dependence on GStreamer plugins (voice playback)
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  runtimeDependencies = [
    libayatana-appindicator # Verified dependence
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/* $out/
    # Delete original desktop file
    rm "$out/share/applications/Rin Chat.desktop"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rin-chat";
      desktopName = "Rin Chat";
      comment = "Chat with AI characters, privately and on your own hardware";
      exec = "rin-chat";
      icon = "rin-chat";
      startupWMClass = "rin-chat";
    })
  ];

  # The deb lists xdg-utils as a dependency, so I'm covering my bases.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
      --set DISABLE_UPDATE_CHECKS 1 # Disables self-update functionality.
    )
  '';

  meta = {
    description = "Chat with AI characters, privately and on your own hardware";
    homepage = "https://rin.chat/";
    changelog = "https://rin.chat/changelog/";
    # No SPDX license. License is shipped inside package. Redistribution allowed both under license, and with express permission from upstream.
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ lib.maintainers.Notarin ];
    platforms = [ "x86_64-linux" ]; # Explicitly x86_64 due to binary input being x86_64.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
