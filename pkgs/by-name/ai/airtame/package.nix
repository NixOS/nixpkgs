{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
  libgcc,
  glib,
  nss,
  nspr,
  at-spi2-atk,
  cups,
  libdrm,
  gtk3,
  pango,
  cairo,
  libgbm,
  expat,
  libxkbcommon,
  alsa-lib,
  libva-minimal,
  pulseaudio,
  libGL,
  vulkan-loader,
  curlWithGnuTls,
  xorg,
  lib,
  libnotify,
  libappindicator-gtk3,
  systemd,
  pciutils,
}:
let
  xorgDeps = with xorg; [
    libXdamage
    libXext
    libXfixes
    libXcomposite
    libXrandr
  ];

  deps = [
    libgcc.lib
    glib
    nss
    nspr
    at-spi2-atk
    cups
    libdrm
    gtk3
    pango
    cairo
    libgbm
    expat
    libxkbcommon
    alsa-lib
    libva-minimal
    pulseaudio
    libGL
    vulkan-loader
    curlWithGnuTls
  ]
  ++ xorgDeps;

  libPath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;
  binPath = lib.makeBinPath deps;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "airtame-application";
  version = "4.14.0";

  src = fetchurl {
    url = "https://downloads.airtame.com/app/latest/linux/Airtame-${finalAttrs.version}.deb";
    hash = "sha256-zOLafN4QFDt2xnn+B8ytz+IvN8R6qje+Sge2Zb5mRZI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = deps;
  runtimeDependencies = [
    (lib.getLib systemd)
    libnotify
    libappindicator-gtk3
    pulseaudio
    pciutils
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/Airtame}
    mv usr/share/* $out/share
    mv opt/Airtame/* $out/share/Airtame

    # Ensure ANGLE libGLESv2.so finds libGL and libvulkan.
    ln -sf ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 $out/share/Airtame/libvulkan.so.1
    patchelf $out/share/Airtame/lib*GL* --set-rpath ${libPath}

    for elf in $out/share/Airtame/{chrome-sandbox,chrome_crashpad_handler}; do
      patchelf $elf --set-rpath ${libPath} --set-interpreter ${stdenv.cc.bintools.dynamicLinker}
    done

    makeBinaryWrapper $out/share/Airtame/airtame-application $out/bin/airtame-application \
      --prefix LD_LIBRARY_PATH : ${libPath} \
      --prefix PATH : ${binPath}

    # Install licenses.
    install -m 644 -D $out/share/Airtame/LICENSE.electron.txt $out/share/licenses/airtame-application/LICENSE.electron.txt
    install -m 644 -D $out/share/Airtame/LICENSES.chromium.html $out/share/licenses/airtame-application/LICENSES.chromium.html

    # Fix the Exec path in the .desktop file.
    sed -i "s|Exec.*$|Exec=$out/bin/airtame-application \$U|" $out/share/applications/airtame-application.desktop

    runHook postInstall
  '';

  meta = {
    description = "Airtame official screen streaming application";
    homepage = "https://airtame.com";
    downloadPage = "https://downloads.airtame.com/app/latest/linux/Airtame-${finalAttrs.version}.deb";
    mainProgram = "airtame-application";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ BastianAsmussen ];
  };
})
