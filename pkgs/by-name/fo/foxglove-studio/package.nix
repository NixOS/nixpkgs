{
  alsa-lib,
  at-spi2-atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  eudev,
  expat,
  fetchurl,
  glib,
  glibc,
  gtk3,
  lib,
  libdrm,
  libgcc,
  libxkbcommon,
  makeWrapper,
  mesa,
  nspr,
  nss,
  pango,
  stdenv,
  systemd,
  via,
  xorg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "foxglove-studio";
  version = "2.18.1";

  src = fetchurl {
    url = "https://get.foxglove.dev/desktop/v${finalAttrs.version}/foxglove-studio-${finalAttrs.version}-linux-amd64.deb";
    sha256 = "sha256-vHloPOmrr8HR9Su5s84xohh8uCpbG4D9eEqbp+jPsDc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    eudev
    expat
    glib
    glibc
    gtk3
    libdrm
    libgcc.libgcc
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    via
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  preFixup = ''
    addAutoPatchelfSearchPath "$out/opt/Foxglove Studio/"
  '';

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -R usr/share opt $out/

    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/foxglove-studio.desktop \
      --replace-fail "/opt/Foxglove Studio/foxglove-studio" "foxglove-studio"
    # symlink the binary to bin/
    ln -s "$out/opt/Foxglove Studio/foxglove-studio" $out/bin/foxglove-studio

    runHook postInstall
  '';

  meta = {
    homepage = "https://foxglove.dev/";
    description = "Platform enabling robotics teams to record, process, visualize, and collaborate on multimodal robot data";
    license = lib.licenses.unfree;
    downloadPage = "https://foxglove.dev/download";
    changelog = "https://docs.foxglove.dev/changelog/foxglove/v${finalAttrs.version}";
    platforms = [
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ lennartrth ];
    mainProgram = "foxglove-studio";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
