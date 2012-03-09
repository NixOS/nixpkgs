{stdenv, fetchurl, xlibs, libX11, libXtst, libSM, libXext, libXv, libXxf86vm, libXau, 
   libXdmcp, zlib, libpng, libxml2, freetype, libICE, intltool, libXinerama, gettext, 
   pkgconfig, kernel, file, libXi}:

stdenv.mkDerivation rec {
  name = "tvtime-1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/tvtime/${name}.tar.gz";
    sha256 = "aef2a4bab084df252428d66cabec61b4c63fab32cdfc0cc6599d82efd77f0523";
  };

  # many of these patches were copied from gentoo's portage team (maybe all?!)
  patchPhase = ''
    # to avoid this error message:
    # ...-glibc-2.12.2/include/xlocale.h:43:20: note: previous declaration of 'locale_t' was here
    patch -p1 < ${ ./tvtime-1.0.2-glibc-2.10.patch}

    # to avoid this error message:
    #  videodev2.h:19:46: fatal error: linux/compiler.h: No such file or directory
    sed -i -e "s/videodev.h/linux\/videodev.h/" src/videoinput.c
    sed -i -e "s/videodev2.h/linux\/videodev2.h/" src/videoinput.c

    # to avoid this error message:
    # 1 out of 2 hunks FAILED -- saving rejects to file src/Makefile.am.rej
    patch -p1 < ${ ./tvtime-1.0.2-libsupc++.patch }

    # to avoid this error message:
    # ../plugins/greedyh.asm:21:6: error: extra qualification 'DScalerFilterGreedyH::' on member 'filterDScaler_SSE'
    patch -p1 < ${ ./tvtime-1.0.2-gcc41.patch }

    # compiles without this patch
    patch -p1 < ${ ./tvtime-pic.patch }

    # compiles without this patch
    patch -p1 < ${ ./tvtime-1.0.2-autotools.patch }

    # compiles without this patch
    patch -p1 < ${ ./tvtime-1.0.2-xinerama.patch }

    # libpng 1.5 patch (gentoo)
    patch -p1 < ${ ./tvtime-libpng-1.5.patch }

    # /usr/bin/file - ltmain.sh configure aclocal.m4
    sed -i -e "s%/usr/bin/file%/nix/store/f92pyxmbi274q7fzrfnlc2xiy6d3cyi1-file-5.04/bi/file%g" ltmain.sh
    sed -i -e "s%/usr/bin/file%/nix/store/f92pyxmbi274q7fzrfnlc2xiy6d3cyi1-file-5.04/bin/file%g" configure
    sed -i -e "s%/usr/bin/file%/nix/store/f92pyxmbi274q7fzrfnlc2xiy6d3cyi1-file-5.04/bin/file%g" aclocal.m4
  '';

  configureFlags = '' 
    --x-includes=${xlibs.libX11}/include 
    --x-libraries=${xlibs.libX11}/lib
  '';

  buildInputs = [ libX11 libXtst libSM libXext libXv libXxf86vm libXau libXdmcp zlib libpng libxml2 freetype libICE intltool libXinerama gettext pkgconfig file libXi ];

  meta = {
    description = "High quality television application for use with video capture cards";
    homepage = lhttp://tvtime.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; linux;
  };
}
