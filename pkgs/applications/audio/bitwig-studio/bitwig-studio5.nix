{
  stdenv,
  fetchurl,
  alsa-lib,
  atk,
  cairo,
  dpkg,
  ffmpeg,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  lcms,
  lib,
  libglvnd,
  libjack2,
  libjpeg,
  libnghttp2,
  libudev-zero,
  libxkbcommon,
  makeWrapper,
  pango,
  pipewire,
  vulkan-loader,
  wrapGAppsHook3,
  xcb-imdkit,
  xdg-utils,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "bitwig-studio-unwrapped";
  version = "5.3.13";

  src = fetchurl {
    name = "bitwig-studio-${version}.deb";
    url = "https://www.bitwig.com/dl/Bitwig%20Studio/${version}/installer_linux/";
    hash = "sha256-tx+Dz9fTm4DIobwLa055ZOCMG+tU7vQl11NFnEKMAno=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  dontBuild = true;
  dontWrapGApps = true; # we only want $gappsWrapperArgs here

  buildInputs = [
    alsa-lib
    atk
    cairo
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    lcms
    libglvnd
    libjack2
    # libjpeg8 is required for converting jpeg's to colour palettes
    libjpeg
    libnghttp2
    xorg.libxcb
    xorg.libXcursor
    xorg.libX11
    xorg.libXtst
    libxkbcommon
    libudev-zero
    pango
    pipewire
    (lib.getLib stdenv.cc.cc)
    vulkan-loader
    xcb-imdkit
    xorg.xcbutil
    xorg.xcbutilwm
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt/bitwig-studio $out/libexec
    ln -s $out/libexec/bitwig-studio $out/bin/bitwig-studio
    cp -r usr/share $out/share

    # Bitwig includes a copy of libxcb-imdkit.
    # Removing it will force it to use our version.
    rm $out/libexec/lib/bitwig-studio/libxcb-imdkit.so.1

    substitute usr/share/applications/com.bitwig.BitwigStudio.desktop \
      $out/share/applications/com.bitwig.BitwigStudio.desktop \
      --replace-fail "Exec=bitwig-studio" "Exec=$out/bin/bitwig-studio"

      runHook postInstall
  '';

  postFixup = ''
    # patchelf fails to set rpath on BitwigStudioEngine, so we use
    # the LD_LIBRARY_PATH way

    find $out -type f -executable \
      -not -name '*.so.*' \
      -not -name '*.so' \
      -not -name '*.jar' \
      -not -name 'jspawnhelper' \
      -not -path '*/resources/*' | \
    while IFS= read -r f ; do
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
      # make xdg-open overrideable at runtime
      wrapProgram $f \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}" \
        --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
        --suffix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath buildInputs}"
    done

    find $out -type f -executable -name 'jspawnhelper' | \
    while IFS= read -r f ; do
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
    done
  '';

  meta = {
    description = "Digital audio workstation";
    longDescription = ''
      Bitwig Studio is a multi-platform music-creation system for
      production, performance and DJing, with a focus on flexible
      editing tools and a super-fast workflow.
    '';
    homepage = "https://www.bitwig.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      bfortz
      michalrus
      mrVanDalo
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
