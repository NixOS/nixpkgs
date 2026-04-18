{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  alsa-lib,
  glib,
  glib-networking,
  gtk3,
  gtk-layer-shell,
  libayatana-appindicator,
  libsoup_3,
  libx11,
  openssl,
  vulkan-loader,
  webkitgtk_4_1,
  xdotool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "handy";
  version = "0.8.2";

  __structuredAttrs = true;
  strictDeps = true;

  src =
    let
      debArch =
        {
          x86_64-linux = "amd64";
          aarch64-linux = "arm64";
        }
        .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/cjpais/Handy/releases/download/v${finalAttrs.version}/Handy_${finalAttrs.version}_${debArch}.deb";
      hash =
        {
          x86_64-linux = "sha256-RtIHytX8WRjG+tzEzhZKfNthYlC8EjoiRZFl42k+MlA=";
          aarch64-linux = "sha256-nkOEhT8HxAeMY+OUKA5skSz9ZdlZ2Ea9r6qNSlqPb/Q=";
        }
        .${stdenv.hostPlatform.system};
    };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    glib
    glib-networking
    gtk3
    gtk-layer-shell
    libsoup_3
    libx11
    openssl
    stdenv.cc.cc.lib
    vulkan-loader
    webkitgtk_4_1
  ];

  runtimeDependencies = [
    libayatana-appindicator
    xdotool
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/bin $out/bin
    cp -r usr/lib $out/lib
    cp -r usr/share $out/share

    # Tauri emits a '256x256@2' icon directory that is not a valid hicolor size;
    # rename to the equivalent 512x512 bucket so the icon is picked up.
    if [ -d "$out/share/icons/hicolor/256x256@2" ]; then
      mv "$out/share/icons/hicolor/256x256@2" "$out/share/icons/hicolor/512x512"
    fi

    # Upstream ships an empty Categories= entry, which is invalid per the XDG
    # Desktop Entry Specification and causes some launchers to hide the app.
    substituteInPlace $out/share/applications/Handy.desktop \
      --replace-fail 'Categories=' 'Categories=Utility;AudioVideo;Accessibility;'

    runHook postInstall
  '';

  meta = {
    description = "Free, open-source, offline speech-to-text application";
    longDescription = ''
      Handy is a privacy-preserving speech-to-text tool built with Tauri:
      press a shortcut, speak, and the transcription is inserted into the
      active text field. All audio is processed locally — nothing is sent
      to the cloud.

      On Linux, the default Paste Method ("Direct", which simulates
      individual keystrokes through rdev/enigo) can fail silently under
      Wayland compositors that restrict synthetic input. If transcriptions
      do not appear in your target application, open Handy's settings and
      switch Paste Method to "Clipboard + Ctrl+V".
    '';
    homepage = "https://handy.computer";
    changelog = "https://github.com/cjpais/Handy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "handy";
    maintainers = with lib.maintainers; [ wondermr ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
