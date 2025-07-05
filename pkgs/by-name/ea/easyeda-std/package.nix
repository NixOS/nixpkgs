{
  stdenv,
  fetchzip,
  alsa-lib,
  nss,
  libdrm,
  mesa,
  vulkan-loader,
  glib,
  nspr,
  atk,
  cups,
  dbus,
  gtk3,
  pango,
  cairo,
  gdk-pixbuf,
  xorg,
  expat,
  libxkbcommon,
  gnome,
  harfbuzzFull,
  electron,
  makeWrapper,
  wrapGAppsHook3,
  autoPatchelfHook,
  patchelf,
  udev,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "easyeda-std";
  version = "6.5.46";

  src = fetchzip {
    url = "https://image.easyeda.com/files/easyeda-linux-x64-${finalAttrs.version}.zip";
    sha256 = "sha256-0aMh8dD3z4A4IA1hlAwz9VeERlRWHe9HV54u7+OyKFM=";
    stripRoot = false;
  };

  propagatedBuildInputs = [ electron ];

  buildInputs = [
    alsa-lib
    nss
    libdrm
    mesa
    vulkan-loader
    glib
    nspr
    atk
    cups
    dbus
    gtk3
    pango
    cairo
    gdk-pixbuf
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    expat
    libxkbcommon
    gnome.gvfs
    harfbuzzFull
    udev
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    patchelf
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/opt $out/share/applications/
    cp -r $src/easyeda-linux-x64/ $out/opt/easyeda
    chmod 755 $out/opt/easyeda/easyeda
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      $out/opt/easyeda/easyeda

    cp $out/opt/easyeda/EASYEDA.dkt $out/share/applications/EASYEDA.desktop
    substituteInPlace $out/share/applications/EASYEDA.desktop \
        --replace 'Exec=/opt/easyeda/easyeda %f' "Exec=easyeda %f"
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/easyeda/easyeda $out/bin/easyeda \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/opt/easyeda \
      --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}
  '';

  meta = {
    description = "EasyEDA Std Edition";
    homepage = "https://easyeda.com/";
    changelog = "https://easyeda.com/page/update-record-v${lib.versions.majorMinor finalAttrs.version}";
    mainProgram = "easyeda";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.shimun ];
  };
})
