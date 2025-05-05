{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  glib,
  at-spi2-atk,
  cairo,
  pango,
  gtk3,
  nss,
  nspr,
  cups,
  dbus,
  libdrm,
  libxkbcommon,
  alsa-lib,
  expat,
  xorg,
  libgbm,
  systemd,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmind";
  version = "25.01.01061-202501070800";

  src = fetchurl {
    url = "https://dl3.xmind.app/Xmind-for-Linux-amd64bit-${finalAttrs.version}.deb";
    hash = "sha256-Mp2aC/yHoB29t9QY4Tnbgn//J8Gordt5S1JrJn0BvXg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    xorg.libX11
    xorg.libXext
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxkbfile
    glib
    at-spi2-atk
    cairo
    pango
    gtk3
    nss
    nspr
    cups
    dbus
    libdrm
    libxkbcommon
    alsa-lib
    expat
    libgbm
  ];

  runtimeDependencies = map lib.getLib [
    systemd
  ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out
    substituteInPlace $out/share/applications/xmind.desktop \
      --replace-fail "/opt/Xmind/xmind" "/opt/Xmind/"
    mkdir -p $out/opt $out/bin
    cp -r opt/Xmind $out/opt/xmind
    ln -s $out/opt/xmind/xmind $out/bin/xmind

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
        ]
      } $out/opt/xmind/xmind
  '';

  meta = {
    description = "All-in-one thinking tool featuring mind mapping, AI generation, and real-time collaboration";
    homepage = "https://xmind.app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "xmind";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ michalrus ];
  };
})
