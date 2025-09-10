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
}:

let
  LD_LIBRARY_PATH = lib.makeLibraryPath [
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
  ];
in
stdenv.mkDerivation (finalAttrs: {
  version = "6.3.4";
  pname = "staruml";

  src = fetchurl {
    url = "https://files.staruml.io/releases-v6/StarUML_${finalAttrs.version}_amd64.deb";
    sha256 = "sha256-Qo5hBdVl/pDBkfBYhNF31P3Tii/V6Iczc7BOvagxjxE=";
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
    mkdir -p $out/bin
    mv opt $out

    mv usr/share $out
    rm -rf $out/share/doc

    substituteInPlace $out/share/applications/staruml.desktop \
      --replace "/opt/StarUML/staruml" "$out/bin/staruml"

    mkdir -p $out/lib
    ln -s ${lib.getLib stdenv.cc.cc}/lib/libstdc++.so.6 $out/lib/
    ln -s ${lib.getLib systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/opt/StarUML/staruml

    ln -s $out/opt/StarUML/staruml $out/bin/staruml
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH ':' $out/lib:${LD_LIBRARY_PATH}
    )
  '';

  meta = with lib; {
    description = "Sophisticated software modeler";
    homepage = "https://staruml.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ kashw2 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "staruml";
  };
})
