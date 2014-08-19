{ stdenv, lib, fetchurl, makeWrapper
, pkgconfig, cmake, gnumake, yasm, pythonFull
, boost, avahi, libdvdcss, lame, autoreconfHook
, gettext, pcre, yajl, fribidi, which
, openssl, gperf, tinyxml2, taglib, libssh, swig, jre
, libX11, xproto, inputproto, libxml2
, libXt, libXmu, libXext, xextproto
, libXinerama, libXrandr, randrproto
, libXtst, libXfixes, fixesproto, systemd
, SDL, SDL_image, SDL_mixer, alsaLib
, mesa, glew, fontconfig, freetype, ftgl
, libjpeg, jasper, libpng, libtiff
, ffmpeg, libmpeg2, libsamplerate, libmad
, libogg, libvorbis, flac, libxslt
, lzo, libcdio, libmodplug, libass, libbluray
, sqlite, mysql, nasm, gnutls, libva
, curl, bzip2, zip, unzip, glxinfo, xdpyinfo
, dbus_libs ? null, dbusSupport ? true
, udev, udevSupport ? true
, libusb ? null, usbSupport ? false
, samba ? null, sambaSupport ? true
, libmicrohttpd
# TODO: would be nice to have nfsSupport (needs libnfs library)
# TODO: librtmp
, libvdpau ? null, vdpauSupport ? true
, pulseaudio ? null, pulseSupport ? true
}:

assert dbusSupport  -> dbus_libs != null;
assert udevSupport  -> udev != null;
assert usbSupport   -> libusb != null && ! udevSupport; # libusb won't be used if udev is avaliable
assert sambaSupport -> samba != null;
assert vdpauSupport -> libvdpau != null && ffmpeg.vdpauSupport;
assert pulseSupport -> pulseaudio != null;

stdenv.mkDerivation rec {
    name = "xbmc-13.1";

    src = fetchurl {
      url = "https://github.com/xbmc/xbmc/archive/13.1-Gotham.tar.gz";
      sha256 = "0y56c5csfp8xhk088g47m3bzrri73z868yfx6b04gnrdmr760jrl";
    };

    buildInputs = [
      makeWrapper libxml2 gnutls
      pkgconfig cmake gnumake yasm pythonFull
      boost libmicrohttpd autoreconfHook
      gettext pcre yajl fribidi libva
      openssl gperf tinyxml2 taglib libssh swig jre
      libX11 xproto inputproto which
      libXt libXmu libXext xextproto
      libXinerama libXrandr randrproto
      libXtst libXfixes fixesproto
      SDL SDL_image SDL_mixer alsaLib
      mesa glew fontconfig freetype ftgl
      libjpeg jasper libpng libtiff
      ffmpeg libmpeg2 libsamplerate libmad
      libogg libvorbis flac libxslt systemd
      lzo libcdio libmodplug libass libbluray
      sqlite mysql nasm avahi libdvdcss lame
      curl bzip2 zip unzip glxinfo xdpyinfo
    ]
    ++ lib.optional dbusSupport dbus_libs
    ++ lib.optional udevSupport udev
    ++ lib.optional usbSupport libusb
    ++ lib.optional sambaSupport samba
    ++ lib.optional vdpauSupport libvdpau
    ++ lib.optional pulseSupport pulseaudio;

    dontUseCmakeConfigure = true;

    preConfigure = ''
      substituteInPlace xbmc/linux/LinuxTimezone.cpp \
        --replace 'usr/share/zoneinfo' 'etc/zoneinfo'
      ./bootstrap
    '';

    configureFlags = [
      "--enable-external-libraries"
    ]
    ++ lib.optional (! sambaSupport) "--disable-samba"
    ++ lib.optional vdpauSupport "--enable-vdpau"
    ++ lib.optional pulseSupport "--enable-pulse";

    postInstall = ''
      for p in $(ls $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH ":" "${pythonFull}/bin" \
          --prefix PATH ":" "${glxinfo}/bin" \
          --prefix PATH ":" "${xdpyinfo}/bin" \
          --prefix LD_LIBRARY_PATH ":" "${curl}/lib" \
          --prefix LD_LIBRARY_PATH ":" "${systemd}/lib" \
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
