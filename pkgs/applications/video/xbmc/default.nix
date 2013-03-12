{ stdenv, lib, fetchurl, makeWrapper
, pkgconfig, cmake, gnumake, yasm, python
, boost
, gettext, pcre, yajl, fribidi
, openssl, gperf, tinyxml2, taglib, libssh, swig, jre
, libX11, xproto, inputproto
, libXt, libXmu, libXext, xextproto
, libXinerama, libXrandr, randrproto
, libXtst, libXfixes, fixesproto
, SDL, SDL_image, SDL_mixer, alsaLib
, mesa, glew, fontconfig, freetype, ftgl
, libjpeg, jasper, libpng, libtiff
, ffmpeg, libmpeg2, libsamplerate, libmad
, libogg, libvorbis, flac
, lzo, libcdio, libmodplug, libass
, sqlite, mysql, nasm
, curl, bzip2, zip, unzip, glxinfo, xdpyinfo
, dbus_libs ? null, dbusSupport ? true
, udev, udevSupport ? true
, libusb ? null, usbSupport ? false
, samba ? null, sambaSupport ? true
# TODO: would be nice to have nfsSupport (needs libnfs library)
, libvdpau ? null, vdpauSupport ? true
}:

assert dbusSupport  -> dbus_libs != null;
assert udevSupport  -> udev != null;
assert usbSupport   -> libusb != null && ! udevSupport; # libusb won't be used if udev is avaliable
assert sambaSupport -> samba != null;
assert vdpauSupport -> libvdpau != null && ffmpeg.vdpauSupport;

stdenv.mkDerivation rec {
    name = "xbmc-12.0";

    src = fetchurl {
      url = "http://mirrors.xbmc.org/releases/source/${name}.tar.gz";
      sha256 = "0vy1a38gfbp9vhbjvwqm11sd76gl3s9q0h7gwpsks85m2k88q0ak";
    };

    buildInputs = [
      makeWrapper
      pkgconfig cmake gnumake yasm python
      boost
      gettext pcre yajl fribidi
      openssl gperf tinyxml2 taglib libssh swig jre
      libX11 xproto inputproto
      libXt libXmu libXext xextproto
      libXinerama libXrandr randrproto
      libXtst libXfixes fixesproto
      SDL SDL_image SDL_mixer alsaLib
      mesa glew fontconfig freetype ftgl
      libjpeg jasper libpng libtiff
      ffmpeg libmpeg2 libsamplerate libmad
      libogg libvorbis flac
      lzo libcdio libmodplug libass
      sqlite mysql nasm
      curl bzip2 zip unzip glxinfo xdpyinfo
    ]
    ++ lib.optional dbusSupport dbus_libs
    ++ lib.optional udevSupport udev
    ++ lib.optional usbSupport libusb
    ++ lib.optional sambaSupport samba
    ++ lib.optional vdpauSupport libvdpau;

    dontUseCmakeConfigure = true;

    configureFlags = [
      "--enable-external-libraries"
      "--disable-webserver"
    ]
    ++ lib.optional (! sambaSupport) "--disable-samba"
    ++ lib.optional vdpauSupport "--enable-vdpau";

    postInstall = ''
      for p in $(ls $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH ":" "${python}/bin" \
          --prefix PATH ":" "${glxinfo}/bin" \
          --prefix PATH ":" "${xdpyinfo}/bin" \
          --prefix LD_LIBRARY_PATH ":" "${curl}/lib" \
          --prefix LD_LIBRARY_PATH ":" "${libvdpau}/lib"
      done
    '';

    meta = {
      homepage = http://xbmc.org/;
      description = "XBMC Media Center";
      license = "GPLv2";
      platforms = stdenv.lib.platforms.linux; 
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
}
