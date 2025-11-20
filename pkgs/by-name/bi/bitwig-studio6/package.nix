{
  stdenv,
  fetchurl,
  alsa-lib,
  atk,
  autoPatchelfHook,
  cairo,
  dpkg,
  ffmpeg,
  freetype,
  gdk-pixbuf,
  giflib,
  glib,
  gtk3,
  harfbuzz,
  lcms,
  lib,
  libglvnd,
  libjack2,
  libjpeg8,
  libX11,
  libxcb,
  libXcursor,
  libxkbcommon,
  libXtst,
  makeWrapper,
  pango,
  pipewire,
  pulseaudio,
  vulkan-loader,
  wrapGAppsHook3,
  xcb-imdkit,
  xcbutil,
  xcbutilwm,
  xdg-utils,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "bitwig-studio";
  version = "6.0";
  dl_version = "6.0";

  src = fetchurl {
    url = "https://www.bitwig.com/dl/Bitwig%20Studio/${dl_version}/installer_linux/";
    hash = "sha256-jrCTgaxfeWhfKwLeKLmqTQWS7RVbVnHqJ0InCipmm8k=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook3
    autoPatchelfHook
  ];

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $curSrc root
  '';

  dontBuild = true;
  dontWrapGApps = true; # we only want $gappsWrapperArgs here

  buildInputs = [
    alsa-lib
    atk
    cairo
    freetype
    gdk-pixbuf
    giflib
    glib
    gtk3
    harfbuzz
    lcms
    libglvnd
    libjack2
    libjpeg8
    libxcb
    libXcursor
    libX11
    libXtst
    libxkbcommon
    pango
    pipewire
    pulseaudio
    stdenv.cc.cc.lib
    vulkan-loader
    xcb-imdkit
    xcbutil
    xcbutilwm
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
      --replace /usr/bin/bitwig-studio $out/bin/bitwig-studio

      runHook postInstall
  '';

  postFixup = ''
    # patchelf fails to set rpath on BitwigStudioEngine, so we use
    # the LD_LIBRARY_PATH way

    find $out -type f -executable \
      -not -name '*.so.*' \
      -not -name '*.so' \
      -not -name '*.jar' \
      -not -path '*/resources/*' | \
    while IFS= read -r f ; do
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
    done

    find $out -type f -executable -name 'Bitwig*PluginHost*' | \
    while IFS= read -r f ; do
      wrapProgram $f \
        "''${gappsWrapperArgs[@]}" \
        --suffix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath buildInputs}"
    done

    find $out -type f -executable \
      -not -name 'Bitwig*PluginHost*' \
      -not -name '*.so.*' \
      -not -name '*.so' \
      -not -name '*.jar' \
      -not -name 'jspawnhelper' \
      -not -path '*/resources/*' | \
    while IFS= read -r f ; do
      # make xdg-open overrideable at runtime
      wrapProgram $f \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}" \
        --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"
    done
  '';

  meta = with lib; {
    description = "Digital audio workstation";
    longDescription = ''
      Bitwig Studio is a multi-platform music-creation system for
      production, performance and DJing, with a focus on flexible
      editing tools and a super-fast workflow.
    '';
    homepage = "https://www.bitwig.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      bfortz
      michalrus
      mrVanDalo
    ];
  };
}
