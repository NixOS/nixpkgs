{ stdenv
, fetchurl
, alsa-lib
, cairo
, dpkg
, ffmpeg
, freetype
, gdk-pixbuf
, glib
, gtk3
, lib
, libglvnd
, libjack2
, libjpeg
, libxkbcommon
, makeWrapper
, pipewire
, pulseaudio
, wrapGAppsHook
, xdg-utils
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "bitwig-studio";
  version = "4.4.10";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/${pname}-${version}.deb";
    sha256 = "sha256-gtQ1mhXk0AqGidZk5TCzSR58pD1JJoELMBmELtqyb4U=";
  };

  nativeBuildInputs = [ dpkg makeWrapper wrapGAppsHook ];

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $curSrc root
  '';

  dontBuild = true;
  dontWrapGApps = true; # we only want $gappsWrapperArgs here

  buildInputs = with xorg; [
    alsa-lib
    cairo
    freetype
    gdk-pixbuf
    glib
    gtk3
    libglvnd
    libjack2
    # libjpeg8 is required for converting jpeg's to colour palettes
    libjpeg
    libxcb
    libXcursor
    libX11
    libXtst
    libxkbcommon
    pipewire
    pulseaudio
    stdenv.cc.cc.lib
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

  meta = with lib; {
    description = "A digital audio workstation";
    longDescription = ''
      Bitwig Studio is a multi-platform music-creation system for
      production, performance and DJing, with a focus on flexible
      editing tools and a super-fast workflow.
    '';
    homepage = "https://www.bitwig.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bfortz michalrus mrVanDalo ];
  };
}
