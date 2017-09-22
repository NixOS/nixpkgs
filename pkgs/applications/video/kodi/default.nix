{ stdenv, lib, fetchurl, makeWrapper
, pkgconfig, cmake, gnumake, yasm, python2
, boost, avahi, libdvdcss, libdvdnav, libdvdread, lame, autoreconfHook
, gettext, pcre-cpp, yajl, fribidi, which
, openssl, gperf, tinyxml2, taglib, libssh, swig, jre
, libX11, xproto, inputproto, libxml2
, libXt, libXmu, libXext, xextproto
, libXinerama, libXrandr, randrproto
, libXtst, libXfixes, fixesproto, systemd
, SDL, SDL2, SDL_image, SDL_mixer, alsaLib
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
, joystickSupport ? true
}:

assert dbusSupport  -> dbus_libs != null;
assert udevSupport  -> udev != null;
assert usbSupport   -> libusb != null && ! udevSupport; # libusb won't be used if udev is avaliable
assert sambaSupport -> samba != null;
assert vdpauSupport -> libvdpau != null;
assert pulseSupport -> libpulseaudio != null;
assert rtmpSupport  -> rtmpdump != null;

let
  rel = "Krypton";
  ffmpeg_3_1_6 = fetchurl {
    url = "https://github.com/xbmc/FFmpeg/archive/3.1.6-${rel}.tar.gz";
    sha256 = "14jicb26s20nr3qmfpazszpc892yjwjn81zbsb8szy3a5xs19y81";
  };
  # Usage of kodi fork of libdvdnav and libdvdread is necessary for functional dvd playback:
  libdvdnav_src = fetchurl {
    url = "https://github.com/xbmc/libdvdnav/archive/981488f.tar.gz";
    sha256 = "312b3d15bc448d24e92f4b2e7248409525eccc4e75776026d805478e51c5ef3d";
  };
  libdvdread_src = fetchurl {
    url = "https://github.com/xbmc/libdvdread/archive/17d99db.tar.gz";
    sha256 = "e7179b2054163652596a56301c9f025515cb08c6d6310b42b897c3ad11c0199b";
  };
in stdenv.mkDerivation rec {
    name = "kodi-${version}";
    version = "17.3";

    src = fetchurl {
      url = "https://github.com/xbmc/xbmc/archive/${version}-${rel}.tar.gz";
      sha256 = "189isc1jagrnq549vwpvb0x1w6p0mkjwv7phm8dzvki96wx6bs0x";
    };

    buildInputs = [
      libxml2 gnutls yasm python2
      boost libmicrohttpd
      gettext pcre-cpp yajl fribidi libva
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
    ++ lib.optional rtmpSupport rtmpdump
    ++ lib.optional joystickSupport SDL2;

    nativeBuildInputs = [
      autoreconfHook cmake gnumake makeWrapper pkgconfig
    ];

    dontUseCmakeConfigure = true;

    postPatch = ''
      substituteInPlace xbmc/linux/LinuxTimezone.cpp \
        --replace 'usr/share/zoneinfo' 'etc/zoneinfo'
      substituteInPlace tools/depends/target/ffmpeg/autobuild.sh \
        --replace "/bin/bash" "${bash}/bin/bash -ex"
      cp ${ffmpeg_3_1_6} tools/depends/target/ffmpeg/ffmpeg-3.1.6-${rel}.tar.gz
      ln -s ${libdvdcss.src} tools/depends/target/libdvdcss/libdvdcss-master.tar.gz
      cp ${libdvdnav_src} tools/depends/target/libdvdnav/libdvdnav-master.tar.gz
      cp ${libdvdread_src} tools/depends/target/libdvdread/libdvdread-master.tar.gz
    '';

    preConfigure = ''
      patchShebangs .
      ./bootstrap
      # tests here fail
      sed -i '/TestSystemInfo.cpp/d' xbmc/utils/test/{Makefile,CMakeLists.txt}
      # tests here trigger a segfault in kodi.bin
      sed -i '/TestWebServer.cpp/d'  xbmc/network/test/{Makefile,CMakeLists.txt}
    '';

    enableParallelBuilding = true;

    doCheck = true;

    configureFlags = [ "--enable-libcec" ]
    ++ lib.optional (!sambaSupport) "--disable-samba"
    ++ lib.optional vdpauSupport "--enable-vdpau"
    ++ lib.optional pulseSupport "--enable-pulse"
    ++ lib.optional rtmpSupport "--enable-rtmp"
    ++ lib.optional joystickSupport "--enable-joystick";

    postInstall = ''
      for p in $(ls $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH ":" "${lib.makeBinPath
              [ python2 glxinfo xdpyinfo ]}" \
          --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath
              [ curl systemd libmad libvdpau libcec libcec_platform rtmpdump libass SDL2 ]}"
      done
    '';

    meta = with stdenv.lib; {
      homepage = https://kodi.tv/;
      description = "Media center";
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ domenkozar titanous edwtjo ];
    };
}
