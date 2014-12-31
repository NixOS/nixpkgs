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
, libmpeg2, libsamplerate, libmad
, libogg, libvorbis, flac, libxslt
, lzo, libcdio, libmodplug, libass, libbluray
, sqlite, mysql, nasm, gnutls, libva, wayland
, curl, bzip2, zip, unzip, glxinfo, xdpyinfo
, dbus_libs ? null, dbusSupport ? true
, udev, udevSupport ? true
, libusb ? null, usbSupport ? false
, samba ? null, sambaSupport ? true
, libmicrohttpd, bash
# TODO: would be nice to have nfsSupport (needs libnfs library)
# TODO: librtmp
, libvdpau ? null, vdpauSupport ? true
, pulseaudio ? null, pulseSupport ? true
, libcec ? null, cecSupport ? true
}:

assert dbusSupport  -> dbus_libs != null;
assert udevSupport  -> udev != null;
assert usbSupport   -> libusb != null && ! udevSupport; # libusb won't be used if udev is avaliable
assert sambaSupport -> samba != null;
assert vdpauSupport -> libvdpau != null;
assert pulseSupport -> pulseaudio != null;
assert cecSupport   -> libcec != null;

let
  ffmpeg_2_4_4 = fetchurl {
    url = "https://github.com/xbmc/FFmpeg/archive/2.4.4-Helix.tar.gz";
    sha256 = "1pkkmnq0kbwb13ps1wk01709lp3l2dzbfay6l29zj1204lbc3anb";
  };
in stdenv.mkDerivation rec {
    name = "kodi-14.0";

    src = fetchurl {
      url = "https://github.com/xbmc/xbmc/archive/14.0-Helix.tar.gz";
      sha256 = "14hip50gg3qgfb0mw7wrdqvw77mxdg9x1abfrqv1ydjrrjansx0i";
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
      libjpeg jasper libpng libtiff wayland
      libmpeg2 libsamplerate libmad
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
    ++ lib.optional pulseSupport pulseaudio
    ++ lib.optional cecSupport libcec;

    dontUseCmakeConfigure = true;

    postPatch = ''
      substituteInPlace xbmc/linux/LinuxTimezone.cpp \
        --replace 'usr/share/zoneinfo' 'etc/zoneinfo'
      substituteInPlace tools/depends/target/ffmpeg/autobuild.sh \
        --replace "/bin/bash" "${bash}/bin/bash -ex"
      cp ${ffmpeg_2_4_4} tools/depends/target/ffmpeg/ffmpeg-2.4.4-Helix.tar.gz
    '';

    preConfigure = ''
      ./bootstrap
    '';

    configureFlags = [
      "--enable-external-libraries"
    ]
    ++ lib.optional (!sambaSupport) "--disable-samba"
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
          --prefix LD_LIBRARY_PATH ":" "${libmad}/lib" \
          --prefix LD_LIBRARY_PATH ":" "${libvdpau}/lib" \
          --prefix LD_LIBRARY_PATH ":" "${libcec}/lib"
      done
    '';

    meta = with stdenv.lib; {
      homepage = http://kodi.tv/;
      description = "Media center";
      license = stdenv.lib.licenses.gpl2;
      platforms = platforms.linux;
      maintainers = [ maintainers.iElectric maintainers.titanous ];
    };
}
