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
, libcec, libcec_platform, dcadec, libuuid
, libcrossguid
, dbus_libs ? null, dbusSupport ? true
, udev, udevSupport ? true
, libusb ? null, usbSupport ? false
, samba ? null, sambaSupport ? true
, libmicrohttpd, bash
# TODO: would be nice to have nfsSupport (needs libnfs library)
, rtmpdump ? null, rtmpSupport ? true
, libvdpau ? null, vdpauSupport ? true
, libpulseaudio ? null, pulseSupport ? true
}:

assert dbusSupport  -> dbus_libs != null;
assert udevSupport  -> udev != null;
assert usbSupport   -> libusb != null && ! udevSupport; # libusb won't be used if udev is avaliable
assert sambaSupport -> samba != null;
assert vdpauSupport -> libvdpau != null;
assert pulseSupport -> libpulseaudio != null;
assert rtmpSupport  -> rtmpdump != null;

let
  rel = "Jarvis";
  ffmpeg_2_8_6 = fetchurl {
    url = "https://github.com/xbmc/FFmpeg/archive/2.8.6-${rel}-16.1.tar.gz";
    sha256 = "1qp8b97298l2pnhhcp7xczdfwr7q7ibxlk4vp8pfmxli2h272wan";
  };
in stdenv.mkDerivation rec {
    name = "kodi-" + version;
    version = "16.1";

    src = fetchurl {
      url = "https://github.com/xbmc/xbmc/archive/${version}-${rel}.tar.gz";
      sha256 = "047xpmz78k3d6nhk1x9s8z0bw1b1w9kca46zxkg86p3iyapwi0kx";
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
      sqlite mysql.lib nasm avahi libdvdcss lame
      curl bzip2 zip unzip glxinfo xdpyinfo
      libcec libcec_platform dcadec libuuid
      libcrossguid
    ]
    ++ lib.optional dbusSupport dbus_libs
    ++ lib.optional udevSupport udev
    ++ lib.optional usbSupport libusb
    ++ lib.optional sambaSupport samba
    ++ lib.optional vdpauSupport libvdpau
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional rtmpSupport rtmpdump;

    dontUseCmakeConfigure = true;

    postPatch = ''
      substituteInPlace xbmc/linux/LinuxTimezone.cpp \
        --replace 'usr/share/zoneinfo' 'etc/zoneinfo'
      substituteInPlace tools/depends/target/ffmpeg/autobuild.sh \
        --replace "/bin/bash" "${bash}/bin/bash -ex"
      cp ${ffmpeg_2_8_6} tools/depends/target/ffmpeg/ffmpeg-2.8.6-${rel}-16.0.tar.gz
    '';

    preConfigure = ''
      ./bootstrap
    '';

    configureFlags = [ ]
    ++ lib.optional (!sambaSupport) "--disable-samba"
    ++ lib.optional vdpauSupport "--enable-vdpau"
    ++ lib.optional pulseSupport "--enable-pulse"
    ++ lib.optional rtmpSupport "--enable-rtmp";

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
          --prefix LD_LIBRARY_PATH ":" "${libcec}/lib" \
          --prefix LD_LIBRARY_PATH ":" "${libcec_platform}/lib" \
          --prefix LD_LIBRARY_PATH ":" "${libass}/lib" \
          --prefix LD_LIBRARY_PATH ":" "${rtmpdump}/lib"
      done
    '';

    meta = with stdenv.lib; {
      homepage = http://kodi.tv/;
      description = "Media center";
      license = stdenv.lib.licenses.gpl2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ iElectric titanous edwtjo ];
    };
}
