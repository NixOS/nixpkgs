{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  xorg,
  libxkbcommon,
  glib,
  gtk3,
  gobject-introspection,
  pango,
  cairo,
  at-spi2-atk,
  dbus,
  cups,
  libdrm,
  libgbm,
  expat,
  alsa-lib,
  nss,
  nspr,
  vulkan-loader,
  systemd,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "scholaread";
  version = "1.1.31";

  src = fetchurl {
    url = "https://cdn.scholaread.cn/assets/pc-releases/${version}/cn/Scholaread-linux-amd64-${version}.deb";
    hash = "sha256-5VYFUb1bK45fzyXul6Cw7T99zZOiglxylKu/YgyE7Rg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXext
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    libxkbcommon
    glib
    gtk3
    gobject-introspection
    pango
    cairo
    at-spi2-atk
    (lib.getLib stdenv.cc.cc)
    dbus
    cups
    libdrm
    libgbm
    expat
    alsa-lib
    nss
    nspr
    vulkan-loader
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/app
    cp -r opt/Scholaread $out/app/scholaread
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/scholaread.desktop \
      --replace-fail "/opt/Scholaread/" ""

    runHook postInstall
  '';

  preFixup = ''
    mkdir $out/bin
    makeWrapper $out/app/scholaread/scholaread $out/bin/scholaread \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          systemd
          (lib.getLib stdenv.cc.cc)
          libGL
        ]
      }"
  '';

  meta = {
    homepage = "https://www.scholaread.cn";
    description = "Advanced academic literature reader enhanced with integrated AI features";
    mainProgram = "scholaread";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
  };
}
