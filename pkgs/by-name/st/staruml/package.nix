{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  hicolor-icon-theme,
  gtk3,
  glib,
  systemd,
  xorg,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  dbus,
  gdk-pixbuf,
  pango,
  cairo,
  expat,
  libdrm,
  libgbm,
  alsa-lib,
  at-spi2-core,
  cups,
  libxkbcommon,
  bintools,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "7.0.0";
  pname = "staruml";

  src = fetchurl {
    url = "https://files.staruml.io/releases-v7/StarUML_${finalAttrs.version}_amd64.deb";
    hash = "sha256-z25qeE2G9F010IE1WFxwIifYqowjB4dpUDgRg38RtQc=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    dpkg
  ];
  buildInputs = [
    glib
    hicolor-icon-theme
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv opt $out

    mv usr/share $out
    rm -rf $out/share/doc

    substituteInPlace $out/share/applications/staruml.desktop \
      --replace-fail "/opt/StarUML/staruml" "$out/bin/staruml"

    mkdir -p $out/lib
    ln -s ${lib.getLib stdenv.cc.cc}/lib/libstdc++.so.6 $out/lib/
    ln -s ${lib.getLib systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    patchelf --interpreter ${bintools.dynamicLinker} --add-needed libGL.so.1 $out/opt/StarUML/staruml

    ln -s $out/opt/StarUML/staruml $out/bin/staruml

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : $out/lib:${
        lib.makeLibraryPath [
          glib
          gtk3
          xorg.libXdamage
          xorg.libX11
          xorg.libxcb
          xorg.libXcomposite
          xorg.libXcursor
          xorg.libXext
          xorg.libXfixes
          xorg.libXi
          xorg.libXrender
          xorg.libXtst
          xorg.libxshmfence
          libxkbcommon
          nss
          nspr
          atk
          at-spi2-atk
          dbus
          gdk-pixbuf
          pango
          cairo
          xorg.libXrandr
          expat
          libdrm
          libgbm
          alsa-lib
          at-spi2-core
          cups
          libGL
        ]
      }
    )
  '';

  meta = {
    description = "Sophisticated software modeler";
    homepage = "https://staruml.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "staruml";
  };
})
