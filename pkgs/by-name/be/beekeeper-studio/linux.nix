{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  glibc,
  gcc,
  glib,
  gtk3,
  pango,
  cairo,
  dbus,
  at-spi2-atk,
  cups,
  libdrm,
  gdk-pixbuf,
  nss,
  nspr,
  xorg,
  alsa-lib,
  expat,
  libxkbcommon,
  libgbm,
  vulkan-loader,
  systemd,
  libGL,
  krb5,
  pname,
  version,
  meta,
  passthru,

}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    meta
    passthru
    ;

  src =
    let
      selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
      arch = selectSystem {
        x86_64-linux = "sha256-hpzvu4SyVLXhQ5wbh5hyx+8tM19SxkKZvlMVhzhDCW4=";
        aarch64-linux = "sha256-s567NOTzTItfOdsABIzYoF8iYSpwDsDzbnLZhUSfT8o=";
      };
    in
    fetchurl {
      url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${finalAttrs.version}/beekeeper-studio_${finalAttrs.version}_${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-hpzvu4SyVLXhQ5wbh5hyx+8tM19SxkKZvlMVhzhDCW4=";
        aarch64-linux = "sha256-s567NOTzTItfOdsABIzYoF8iYSpwDsDzbnLZhUSfT8o=";
      };
    };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    libxkbcommon
    glibc
    gcc
    libGL
    glib
    gtk3
    pango
    cairo
    dbus
    at-spi2-atk
    cups
    libdrm
    gdk-pixbuf
    nss
    nspr
    alsa-lib
    expat
    libgbm
    vulkan-loader
    krb5
  ];

  runtimeDependencies = map lib.getLib [ systemd ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out
    substituteInPlace $out/share/applications/beekeeper-studio.desktop \
      --replace-fail '"/opt/Beekeeper Studio/beekeeper-studio"' "beekeeper-studio"
    mkdir -p $out/opt $out/bin
    cp -r opt/"Beekeeper Studio" $out/opt/beekeeper-studio
    makeWrapper $out/opt/beekeeper-studio/beekeeper-studio-bin $out/bin/beekeeper-studio \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-needed libEGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
        ]
      } $out/opt/beekeeper-studio/beekeeper-studio-bin
  '';
})
