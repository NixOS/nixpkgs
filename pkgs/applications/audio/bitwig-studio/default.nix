{ stdenv, fetchurl, alsaLib, bzip2, cairo, dpkg, ffmpeg, freetype, gdk_pixbuf
, glib, gtk2, harfbuzz, jdk, lib, libX11, libXau, libXcursor, libXdmcp
, libXext, libXfixes, libXrender, libbsd, libjack2, libpng, libxcb
, libxkbcommon, libxkbfile, makeWrapper, pixman, xcbutil, xcbutilwm
, xdg_utils, zenity, zlib }:

stdenv.mkDerivation rec {
  name = "bitwig-studio-${version}";
  version = "2.0";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "1m7wdr0f9xi9s7q8vd66hy7fj1k0j3y5ln2yqbjwr76r9g6gkzas";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  libPath = lib.makeLibraryPath [
    alsaLib bzip2.out cairo freetype gdk_pixbuf glib gtk2 harfbuzz
    libX11 libXau libXcursor libXdmcp libXext libXfixes libXrender
    libbsd libjack2 libpng libxcb libxkbfile pixman xcbutil xcbutilwm
    zlib
  ];

  binPath = lib.makeBinPath [
    ffmpeg xdg_utils zenity
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
      patchelf \
        --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
        $f && \
      wrapProgram $f \
        --prefix PATH : "${binPath}" \
        --prefix LD_LIBRARY_PATH : "${libPath}" \
        --set LD_PRELOAD "${libxkbcommon.out}/lib/libxkbcommon.so" || true
    done

    mkdir -p $out/bin
    ln -s $out/libexec/bitwig-studio $out/bin/bitwig-studio

    cp -r usr/share $out/share
  '';

  meta = with stdenv.lib; {
    description = "A digital audio workstation";
    longDescription = ''
      Bitwig Studio is a multi-platform music-creation system for
      production, performance and DJing, with a focus on flexible
      editing tools and a super-fast workflow.
    '';
    homepage = http://www.bitwig.com/;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ michalrus ];
  };
}
