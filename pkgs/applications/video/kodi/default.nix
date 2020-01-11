{ stdenv, lib, fetchurl, fetchFromGitHub, autoconf, automake, libtool, makeWrapper, linuxHeaders
, pkgconfig, cmake, gnumake, yasm, python2Packages
, libgcrypt, libgpgerror, libunistring
, boost, avahi, lame, autoreconfHook
, gettext, pcre-cpp, yajl, fribidi, which
, openssl, gperf, tinyxml2, taglib, libssh, swig, jre
, libX11, xorgproto, libxml2
, libXt, libXmu, libXext
, libXinerama, libXrandr
, libXtst, libXfixes, systemd
, alsaLib, libGLU, libGL, glew, fontconfig, freetype, ftgl
, libjpeg, libpng, libtiff
, libmpeg2, libsamplerate, libmad
, libogg, libvorbis, flac, libxslt
, lzo, libcdio, libmodplug, libass, libbluray
, sqlite, libmysqlclient, nasm, gnutls, libva, libdrm
, curl, bzip2, zip, unzip, glxinfo, xdpyinfo
, libcec, libcec_platform, dcadec, libuuid
, libcrossguid, libmicrohttpd
, bluez, doxygen, giflib, glib, harfbuzz, lcms2, libidn, libpthreadstubs, libtasn1, libXdmcp
, libplist, p11-kit, zlib, flatbuffers, fmt, fstrcmp, rapidjson
, dbusSupport ? true, dbus ? null
, joystickSupport ? true, cwiid ? null
, nfsSupport ? true, libnfs ? null
, pulseSupport ? true, libpulseaudio ? null
, rtmpSupport ? true, rtmpdump ? null
, sambaSupport ? true, samba ? null
, udevSupport ? true, udev ? null
, usbSupport  ? false, libusb ? null
, vdpauSupport ? true, libvdpau ? null
, useWayland ? false, wayland ? null, wayland-protocols ? null
, waylandpp ?  null, libxkbcommon ? null
}:

assert dbusSupport  -> dbus != null;
assert nfsSupport   -> libnfs != null;
assert pulseSupport -> libpulseaudio != null;
assert rtmpSupport  -> rtmpdump != null;
assert sambaSupport -> samba != null;
assert udevSupport  -> udev != null;
assert usbSupport   -> libusb != null && ! udevSupport; # libusb won't be used if udev is avaliable
assert vdpauSupport -> libvdpau != null;
assert useWayland -> wayland != null && wayland-protocols != null && waylandpp != null && libxkbcommon != null;

let
  kodiReleaseDate = "20191116";
  kodiVersion = "18.5";
  rel = "Leia";

  kodi_src = fetchFromGitHub {
    owner  = "xbmc";
    repo   = "xbmc";
    rev    = "${kodiVersion}-${rel}";
    sha256 = "0pcrraj1ddzrd296br10yjnaxgb3iym74xzixcakaqhhp00f5hf6";
  };

  cmakeProto = fetchurl {
    url = "https://raw.githubusercontent.com/pramsey/libght/ca9b1121c352ea10170636e170040e1af015bad1/cmake/modules/CheckPrototypeExists.cmake";
    sha256  = "1zai82gm5x55n3xvdv7mns3ja6a2k81x9zz0nk42j6s2yb0fkjxh";
  };

  cmakeProtoPatch = ''
    # get rid of windows headers as they will otherwise be found first
    rm -rf msvc

    cp ${cmakeProto} cmake/${cmakeProto.name}
    # we need to enable support for C++ for check_prototype_exists to do its thing
    substituteInPlace CMakeLists.txt --replace 'LANGUAGES C' 'LANGUAGES C CXX'
    if [ -f cmake/CheckHeadersSTDC.cmake ]; then
      sed -i cmake/CheckHeadersSTDC.cmake \
        -e '7iinclude(CheckPrototypeExists)'
    fi
  '';

  kodiDependency = { name, version, rev, sha256, ... } @attrs:
    let
      attrs' = builtins.removeAttrs attrs ["name" "version" "rev" "sha256"];
    in stdenv.mkDerivation ({
      name = "kodi-${lib.toLower name}-${version}";
      src = fetchFromGitHub {
        owner = "xbmc";
        repo  = name;
        inherit rev sha256;
      };
      enableParallelBuilding = true;
    } // attrs');

  ffmpeg = kodiDependency rec {
    name    = "FFmpeg";
    version = "4.0.3";
    rev     = "${version}-${rel}-18.2";
    sha256  = "1krsjlr949iy5l6ljxancza1yi6w1annxc5s6k283i9mb15qy8cy";
    preConfigure = ''
      cp ${kodi_src}/tools/depends/target/ffmpeg/{CMakeLists.txt,*.cmake} .
    '';
    buildInputs = [ gnutls libidn libtasn1 p11-kit zlib libva ]
      ++ lib.optional  vdpauSupport    libvdpau;
    nativeBuildInputs = [ cmake nasm pkgconfig ];
  };

  # We can build these externally but FindLibDvd.cmake forces us to build it
  # them, so we currently just use them for the src.
  libdvdcss = kodiDependency rec {
    name              = "libdvdcss";
    version           = "1.4.2";
    rev               = "${version}-${rel}-Beta-5";
    sha256            = "0j41ydzx0imaix069s3z07xqw9q95k7llh06fc27dcn6f7b8ydyl";
    buildInputs       = [ linuxHeaders ];
    nativeBuildInputs = [ cmake pkgconfig ];
    postPatch = ''
      rm -rf msvc

      substituteInPlace config.h.cm \
        --replace '#cmakedefine O_BINARY "''${O_BINARY}"' '#define O_BINARY 0'
    '';
    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=1"
      "-DHAVE_LINUX_DVD_STRUCT=1"
    ];
  };

  libdvdnav = kodiDependency rec {
    name              = "libdvdnav";
    version           = "6.0.0";
    rev               = "${version}-${rel}-Alpha-3";
    sha256            = "0qwlf4lgahxqxk1r2pzl866mi03pbp7l1fc0rk522sc0ak2s9jhb";
    buildInputs       = [ libdvdcss libdvdread ];
    nativeBuildInputs = [ cmake pkgconfig ];
    postPatch         = cmakeProtoPatch;
    postInstall = ''
      mv $out/lib/liblibdvdnav.so $out/lib/libdvdnav.so
    '';
  };

  libdvdread = kodiDependency rec {
    name              = "libdvdread";
    version           = "6.0.0";
    rev               = "${version}-${rel}-Alpha-3";
    sha256            = "1xxn01mhkdnp10cqdr357wx77vyzfb5glqpqyg8m0skyi75aii59";
    buildInputs       = [ libdvdcss ];
    nativeBuildInputs = [ cmake pkgconfig ];
    configureFlags    = [ "--with-libdvdcss" ];
    postPatch         = cmakeProtoPatch;
  };

in stdenv.mkDerivation {
    name = "kodi-${lib.optionalString useWayland "wayland-"}${kodiVersion}";

    src = kodi_src;

    buildInputs = [
      gnutls libidn libtasn1 nasm p11-kit
      libxml2 yasm python2Packages.python
      boost libmicrohttpd
      gettext pcre-cpp yajl fribidi libva libdrm
      openssl gperf tinyxml2 taglib libssh swig jre
      libX11 xorgproto libXt libXmu libXext
      libXinerama libXrandr libXtst libXfixes
      alsaLib libGL libGLU glew fontconfig freetype ftgl
      libjpeg libpng libtiff
      libmpeg2 libsamplerate libmad
      libogg libvorbis flac libxslt systemd
      lzo libcdio libmodplug libass libbluray
      sqlite libmysqlclient avahi lame
      curl bzip2 zip unzip glxinfo xdpyinfo
      libcec libcec_platform dcadec libuuid
      libgcrypt libgpgerror libunistring
      libcrossguid cwiid libplist
      bluez giflib glib harfbuzz lcms2 libpthreadstubs libXdmcp
      ffmpeg flatbuffers fmt fstrcmp rapidjson
      # libdvdcss libdvdnav libdvdread
    ]
    ++ lib.optional  dbusSupport     dbus
    ++ lib.optionals joystickSupport [ cwiid ]
    ++ lib.optional  nfsSupport      libnfs
    ++ lib.optional  pulseSupport    libpulseaudio
    ++ lib.optional  rtmpSupport     rtmpdump
    ++ lib.optional  sambaSupport    samba
    ++ lib.optional  udevSupport     udev
    ++ lib.optional  usbSupport      libusb
    ++ lib.optional  vdpauSupport    libvdpau
    ++ lib.optionals useWayland [
      wayland waylandpp
      # Not sure why ".dev" is needed here, but CMake doesn't find libxkbcommon otherwise
      libxkbcommon.dev
    ];

    nativeBuildInputs = [
      cmake
      doxygen
      makeWrapper
      which
      pkgconfig gnumake
      autoconf automake libtool # still needed for some components. Check if that is the case with 19.0
    ] ++ lib.optionals useWayland [ wayland-protocols ];

    cmakeFlags = [
      "-Dlibdvdcss_URL=${libdvdcss.src}"
      "-Dlibdvdnav_URL=${libdvdnav.src}"
      "-Dlibdvdread_URL=${libdvdread.src}"
      "-DGIT_VERSION=${kodiReleaseDate}"
      "-DENABLE_EVENTCLIENTS=ON"
      "-DENABLE_INTERNAL_CROSSGUID=OFF"
      "-DENABLE_OPTICAL=ON"
      "-DLIRC_DEVICE=/run/lirc/lircd"
    ] ++ lib.optional useWayland [
      "-DCORE_PLATFORM_NAME=wayland"
      "-DWAYLAND_RENDER_SYSTEM=gl"
    ];

    enableParallelBuilding = true;

    # 14 tests fail but the biggest issue is that every test takes 30 seconds -
    # I'm guessing there is a thing waiting to time out
    doCheck = false;

    postPatch = ''
      substituteInPlace xbmc/platform/linux/LinuxTimezone.cpp \
        --replace 'usr/share/zoneinfo' 'etc/zoneinfo'
    '';

    postInstall = ''
      for p in $(ls $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH            ":" "${lib.makeBinPath [ python2Packages.python glxinfo xdpyinfo ]}" \
          --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath
              ([ curl systemd libmad libvdpau libcec libcec_platform rtmpdump libass ] ++ lib.optional nfsSupport libnfs)}"
      done

      substituteInPlace $out/share/xsessions/kodi.desktop \
        --replace kodi-standalone $out/bin/kodi-standalone
    '';

    doInstallCheck = true;

    installCheckPhase = "$out/bin/kodi --version";

    passthru = {
      pythonPackages = python2Packages;
    };

    meta = with stdenv.lib; {
      description = "Media center";
      homepage    = https://kodi.tv/;
      license     = licenses.gpl2;
      platforms   = platforms.linux;
      maintainers = with maintainers; [ domenkozar titanous edwtjo peterhoeg sephalon ];
    };
}
