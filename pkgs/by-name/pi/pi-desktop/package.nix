{
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fetchurl,
  glib,
  gtk3,
  lib,
  libdrm,
  libgbm,
  libnotify,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxtst,
  makeWrapper,
  nspr,
  nss,
  nix-update-script,
  pango,
  stdenv,
  systemd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pi-desktop";
  version = "0.15.8";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/vastsa/PI-Desktop/releases/download/v${finalAttrs.version}/pi-desktop_${finalAttrs.version}_amd64.deb";
    hash = "sha256-1nayhrsGCfXqyQ4k/fxFB7Lr3KD0mpw7nFhClUo3ss4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];
  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libnotify
    libsecret
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxscrnsaver
    libxtst
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
  ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    dpkg-deb -x "$src" "$out"
    mv "$out/usr/share" "$out/share"
    rmdir "$out/usr"
    mkdir -p "$out/bin"
    makeWrapper "$out/opt/PI-Desktop/pi-desktop" "$out/bin/pi-desktop"
    substituteInPlace "$out/share/applications/pi-desktop.desktop" \
      --replace-fail 'Exec=/opt/PI-Desktop/pi-desktop' "Exec=$out/bin/pi-desktop"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "Local-first AI coding agent desktop";
    homepage = "https://github.com/vastsa/PI-Desktop";
    changelog = "https://github.com/vastsa/PI-Desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ ign1x ];
    mainProgram = "pi-desktop";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
