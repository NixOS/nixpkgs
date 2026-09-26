{
  autoPatchelfHook,
  cairo,
  dbus,
  dpkg,
  fetchurl,
  gdk-pixbuf,
  glib,
  glib-networking,
  gtk3,
  lib,
  libayatana-appindicator,
  libx11,
  libxtst,
  libsoup_3,
  nix-update-script,
  openssl,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "deepseek-harness-desktop";
  version = "0.17.2";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/dsh-tauri/deepseek-harness-desktop/releases/download/v${finalAttrs.version}/Deepseek.Harness.Desktop_${finalAttrs.version}_amd64.deb";
    hash = "sha256-RUFWWt0bwz7zWyB/Kp9nxqxGZmbBe2WNKxRxBTB96Ig=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    glib-networking
    gtk3
    libx11
    libxtst
    libsoup_3
    openssl
    webkitgtk_4_1
    stdenv.cc.cc.lib
  ];

  # Tauri loads the status indicator library at runtime rather than linking it.
  runtimeDependencies = [ libayatana-appindicator ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    dpkg-deb -x "$src" "$out"
    mv "$out/usr/bin" "$out/bin"
    mv "$out/usr/lib" "$out/lib"
    mv "$out/usr/share" "$out/share"
    rmdir "$out/usr"

    mv "$out/share/applications/Deepseek Harness Desktop.desktop" \
      "$out/share/applications/deepseek-harness-desktop.desktop"
    substituteInPlace "$out/share/applications/deepseek-harness-desktop.desktop" \
      --replace-fail 'Exec=deepseek-harness-desktop' "Exec=$out/bin/deepseek-harness-desktop"

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default WEBKIT_DISABLE_COMPOSITING_MODE 1
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
    )
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "Desktop application for DeepSeek Harness";
    homepage = "https://github.com/dsh-tauri/deepseek-harness-desktop";
    changelog = "https://github.com/dsh-tauri/deepseek-harness-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ign1x ];
    mainProgram = "deepseek-harness-desktop";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
