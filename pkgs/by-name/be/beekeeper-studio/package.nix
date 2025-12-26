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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beekeeper-studio";
  version = "5.3.4";

  src =
    let
      selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${finalAttrs.version}/beekeeper-studio_${finalAttrs.version}_${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-JSgZ/rDR3d2aKWuclE9tB5538fcMSShjx9gkzkp/7GA=";
        aarch64-linux = "sha256-RsBw4jXcTA2WS1eMleAdljdw8ur0kf2WoQW3dNol2FA=";
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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more";
    homepage = "https://www.beekeeperstudio.io";
    changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "beekeeper-studio";
    maintainers = with lib.maintainers; [
      milogert
      alexnortung
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    knownVulnerabilities = [ "Electron version 31 is EOL" ];
  };
})
