{
  autoPatchelfHook,
  cairo,
  dbus,
  dpkg,
  fetchurl,
  gdk-pixbuf,
  glib,
  glib-networking,
  gst_all_1,
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
  pname = "agentero";
  version = "0.11.4";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/poco-ai/Agentero/releases/download/v${finalAttrs.version}/Agentero_${finalAttrs.version}_amd64.deb";
    hash = "sha256-Zm5FfCmCn9p94pPjg40PoTAPS66CaQYTy8zxerC0bss=";
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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    libx11
    libxtst
    libsoup_3
    openssl
    webkitgtk_4_1
    stdenv.cc.cc.lib
  ];

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

    substituteInPlace "$out/share/applications/Agentero.desktop" \
      --replace-fail 'Exec=agentero' "Exec=$out/bin/agentero"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "Research workspace for collaboration between people and AI agents";
    homepage = "https://github.com/poco-ai/Agentero";
    changelog = "https://github.com/poco-ai/Agentero/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ign1x ];
    mainProgram = "agentero";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
