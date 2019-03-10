{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, makeWrapper
, pkgconfig, cmake, gnumake, yasm, python2Packages
, libgcrypt, libgpgerror, libunistring
, boost, avahi, lame, autoreconfHook
, gettext, pcre-cpp, yajl, fribidi, which
, openssl, gperf, tinyxml2, taglib, libssh, swig, jre
, libX11, xorgproto, libxml2
, libXt, libXmu, libXext
, libXinerama, libXrandr
, libXtst, libXfixes, systemd
, alsaLib, libGLU_combined, glew, fontconfig, freetype, ftgl
, libjpeg, jasper, libpng, libtiff
, libmpeg2, libsamplerate, libmad
, libogg, libvorbis, flac, libxslt
, lzo, libcdio, libmodplug, libass, libbluray
, sqlite, mysql, nasm, gnutls, libva, libdrm, wayland
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
}:

assert dbusSupport  -> dbus != null;
assert nfsSupport   -> libnfs != null;
assert pulseSupport -> libpulseaudio != null;
assert rtmpSupport  -> rtmpdump != null;
assert sambaSupport -> samba != null;
assert udevSupport  -> udev != null;
assert usbSupport   -> libusb != null && ! udevSupport; # libusb won't be used if udev is avaliable
assert vdpauSupport -> libvdpau != null;

# TODO for Kodi 18.0
# - check if dbus support PR has been merged and add dbus as a buildInput

let
  kodiReleaseDate = "20190129";
  kodiVersion = "18.0";
  rel = "Leia";

  kodi_src = fetchFromGitHub {
    owner  = "xbmc";
    repo   = "xbmc";
    rev    = "${kodiVersion}-${rel}";
    sha256 = "1ci5jjvqly01lysdp6j6jrnn49z4is9z5kan5zl3cpqm9w7rqarg";
  };

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
    rev     = "${version}-${rel}-RC5";
    sha256  = "0l20bysv2y711khwpnpw4dz6mzd37qllki3fnv4dx1lj8ivydrlx";
    preConfigure = ''
      cp ${kodi_src}/tools/depends/target/ffmpeg/{CMakeLists.txt,*.cmake} .
    '';
    buildInputs = [ gnutls libidn libtasn1 p11-kit zlib libva ]
      ++ lib.optional  vdpauSupport    libvdpau;
    nativeBuildInputs = [ cmake nasm pkgconfig ];
  };

  # we should be able to build these externally and have kodi reference them as buildInputs.
  # Doesn't work ATM though so we just use them for the src

  libdvdcss = kodiDependency rec {
    name              = "libdvdcss";
    version           = "1.4.2";
    rev               = "${version}-${rel}-Beta-5";
    sha256            = "0j41ydzx0imaix069s3z07xqw9q95k7llh06fc27dcn6f7b8ydyl";
    buildInputs       = [ libdvdread ];
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
  };

  libdvdnav = kodiDependency rec {
    name              = "libdvdnav";
    version           = "6.0.0";
    rev               = "${version}-${rel}-Alpha-3";
    sha256            = "0qwlf4lgahxqxk1r2pzl866mi03pbp7l1fc0rk522sc0ak2s9jhb";
    buildInputs       = [ libdvdread ];
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
  };

  libdvdread = kodiDependency rec {
    name              = "libdvdread";
    version           = "6.0.0";
    rev               = "${version}-${rel}-Alpha-3";
    sha256            = "1xxn01mhkdnp10cqdr357wx77vyzfb5glqpqyg8m0skyi75aii59";
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
  };

in stdenv.mkDerivation rec {
    name = "kodi-${kodiVersion}";

    src = kodi_src;

    buildInputs = [
      gnutls libidn libtasn1 nasm p11-kit
      libxml2 yasm python2Packages.python
      boost libmicrohttpd
      gettext pcre-cpp yajl fribidi libva libdrm
      openssl gperf tinyxml2 taglib libssh swig jre
      libX11 xorgproto libXt libXmu libXext
      libXinerama libXrandr libXtst libXfixes
      alsaLib libGLU_combined glew fontconfig freetype ftgl
      libjpeg jasper libpng libtiff wayland
      libmpeg2 libsamplerate libmad
      libogg libvorbis flac libxslt systemd
      lzo libcdio libmodplug libass libbluray
      sqlite mysql.connector-c avahi lame
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
    ++ lib.optional  vdpauSupport    libvdpau;

    nativeBuildInputs = [
      cmake
      doxygen
      makeWrapper
      which
      pkgconfig gnumake
      autoconf automake libtool # still needed for some components. Check if that is the case with 18.0
    ];

    cmakeFlags = [
      "-Dlibdvdcss_URL=${libdvdcss.src}"
      "-Dlibdvdnav_URL=${libdvdnav.src}"
      "-Dlibdvdread_URL=${libdvdread.src}"
      "-DGIT_VERSION=${kodiReleaseDate}"
      "-DENABLE_EVENTCLIENTS=ON"
      "-DENABLE_INTERNAL_CROSSGUID=OFF"
      "-DENABLE_OPTICAL=ON"
      "-DLIRC_DEVICE=/run/lirc/lircd"
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
