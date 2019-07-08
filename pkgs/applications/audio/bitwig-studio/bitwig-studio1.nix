{ stdenv, fetchurl, alsaLib, bzip2, cairo, dpkg, freetype, gdk_pixbuf
, wrapGAppsHook, gtk2, gtk3, harfbuzz, jdk, lib, xorg
, libbsd, libjack2, libpng, ffmpeg
, libxkbcommon
, makeWrapper, pixman, autoPatchelfHook
, xdg_utils, zenity, zlib }:

stdenv.mkDerivation rec {
  name = "bitwig-studio-${version}";
  version = "1.3.16";

  src = fetchurl {
    url    = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "0n0fxh9gnmilwskjcayvjsjfcs3fz9hn00wh7b3gg0cv3qqhich8";
  };

  nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook wrapGAppsHook ];

  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";

  dontBuild    = true;
  dontWrapGApps = true; # we only want $gappsWrapperArgs here

  buildInputs = with xorg; [
    alsaLib bzip2.out cairo freetype gdk_pixbuf gtk2 gtk3 harfbuzz libX11 libXau
    libXcursor libXdmcp libXext libXfixes libXrender libbsd libjack2 libpng libxcb
    libxkbfile pixman xcbutil xcbutilwm zlib
  ];

  binPath = lib.makeBinPath [
    xdg_utils zenity ffmpeg
  ];

  installPhase = ''
    mkdir -p $out
    cp -r opt/bitwig-studio $out/libexec

    # Use NixOS versions of these libs instead of the bundled ones.
    (
      cd $out/libexec/lib/bitwig-studio
      rm libbz2.so* libxkbfile.so* libXcursor.so* libXau.so* \
         libXdmcp.so* libpng16.so* libxcb*.so* libharfbuzz.so* \
         libcairo.so* libfreetype.so*
      ln -s ${bzip2.out}/lib/libbz2.so.1.0.6 libbz2.so.1.0
    )

    # Use our OpenJDK instead of Bitwig’s bundled—and commercial!—one.
    rm -rf $out/libexec/lib/jre
    ln -s ${jdk.home}/jre $out/libexec/lib/jre

    mkdir -p $out/bin
    ln -s $out/libexec/bitwig-studio $out/bin/bitwig-studio

    cp -r usr/share $out/share
    substitute usr/share/applications/bitwig-studio.desktop \
      $out/share/applications/bitwig-studio.desktop \
      --replace /usr/bin/bitwig-studio $out/bin/bitwig-studio
  '';

  postFixup = ''
    # Bitwig’s `libx11-windowing-system.so` has several problems:
    #
    #   • has some old version of libxkbcommon linked statically (ಠ_ಠ),
    #
    #   • hardcodes path to `/usr/share/X11/xkb`,
    #
    #   • even if we redirected it with libredirect (after adding
    #     `eaccess()` to libredirect!), their version of libxkbcommon
    #     is unable to parse our xkeyboardconfig. Been there, done that.
    #
    # However, it suffices to override theirs with our libxkbcommon
    # in LD_PRELOAD. :-)

    find $out -type f -executable \
      -not -name '*.so.*' \
      -not -name '*.so' \
      -not -path '*/resources/*' | \
    while IFS= read -r f ; do
      wrapProgram $f \
        --prefix PATH : "${binPath}" \
        "''${gappsWrapperArgs[@]}" \
        --set LD_PRELOAD "${libxkbcommon.out}/lib/libxkbcommon.so" || true
    done
  '';

  meta = with stdenv.lib; {
    description = "A digital audio workstation";
    longDescription = ''
      Bitwig Studio is a multi-platform music-creation system for
      production, performance and DJing, with a focus on flexible
      editing tools and a super-fast workflow.
    '';
    homepage = https://www.bitwig.com/;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ michalrus mrVanDalo ];
  };
}
