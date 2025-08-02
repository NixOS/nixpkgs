{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libGL,
  libgbm,
  libxkbcommon,
  musl,
  nspr,
  nss,
  pango,
  udev,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sparkle";
  version = "1.6.10";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://github.com/xishang0128/sparkle/releases/download/${finalAttrs.version}/sparkle-linux-${finalAttrs.version}-${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-07hgkZi3WVBz0pLo871tfzV5uUlAx8hizaDshpo5eOg=";
        aarch64-linux = "sha256-N/oEer06zhn23/p6jQaZ8pCkE9F8dzIHL5n7kvHP8X0=";
      };
    };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libGL
    libgbm
    libxkbcommon
    musl
    nspr
    nss
    pango
    udev
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    chmod 0755 opt/sparkle/resources/files/sysproxy
    cp -r opt $out/opt
    substituteInPlace usr/share/applications/sparkle.desktop \
      --replace-fail "/opt/sparkle/sparkle" "sparkle"
    cp -r usr/share $out/share
    ln -s $out/opt/sparkle/sparkle $out/bin/sparkle

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 $out/opt/sparkle/sparkle
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/xishang0128/sparkle";
    license = lib.licenses.gpl3Plus;
    mainProgram = "sparkle";
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
