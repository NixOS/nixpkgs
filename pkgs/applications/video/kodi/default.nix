{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, makeWrapper
, pkgconfig, cmake, gnumake, yasm, python2Packages
, libgcrypt, libgpgerror, libunistring
, boost, avahi, lame, autoreconfHook
, gettext, pcre-cpp, yajl, fribidi, which
, openssl, gperf, tinyxml2, taglib, libssh, swig, jre
, libX11, xproto, inputproto, libxml2
, libXt, libXmu, libXext, xextproto
, libXinerama, libXrandr, randrproto
, libXtst, libXfixes, fixesproto, systemd
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
, libplist, p11-kit, zlib
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
# - cmake is no longer in project/cmake
# - maybe we can remove auto{conf,make} and libtool from inputs
# - check if dbus support PR has been merged and add dbus as a buildInput
# - try to use system ffmpeg (kodi 17 works best with bundled 3.1 with patches)

let
  kodiReleaseDate = "20171115";
  kodiVersion = "17.6";
  rel = "Krypton";

  kodi_src = fetchFromGitHub {
    owner  = "xbmc";
    repo   = "xbmc";
    rev    = "${kodiVersion}-${rel}";
    sha256 = "1pwmmbry7dajwdpmc1mdygjvxna4kl38h32d71g10yf3mdm5wmz3";
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
    version = "3.1.11";
    rev     = "${version}-${rel}-17.5"; # TODO: change 17.5 back to ${kodiVersion}
    sha256  = "0nc4sb6v1g3l11v9h5l9n44a8r40186rcbp2xg5c7vg6wcpjid13";
    preConfigure = ''
      cp ${kodi_src}/tools/depends/target/ffmpeg/{CMakeLists.txt,*.cmake} .
    '';
    buildInputs = [ gnutls libidn libtasn1 p11-kit zlib libva ]
      ++ lib.optional  vdpauSupport    libvdpau;
    nativeBuildInputs = [ cmake nasm pkgconfig ];
  };

  # we should be able to build these externally and have kodi reference them as buildInputs.
  # Doesn't work ATM though so we just use them for the src

  libdvdcss = kodiDependency {
    name              = "libdvdcss";
    version           = "20160215";
    rev               = "2f12236bc1c92f73c21e973363f79eb300de603f";
    sha256            = "198r0q73i55ga1dvyqq9nfcri0zq08b94hy8671lg14i3izx44dd";
    buildInputs       = [ libdvdread ];
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
  };

  libdvdnav = kodiDependency {
    name              = "libdvdnav";
    version           = "20170217";
    rev               = "981488f7f27554b103cca10c1fbeba027396c94a";
    sha256            = "089pswc51l3avh95zl4cpsh7gh1innh7b2y4xgx840mcmy46ycr8";
    buildInputs       = [ libdvdread ];
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
  };

  libdvdread = kodiDependency {
    name              = "libdvdread";
    version           = "20160221";
    rev               = "17d99db97e7b8f23077b342369d3c22a6250affd";
    sha256            = "1gr5aq1cjr3as9mnwrw29cxn4m6f6pfrxdahkdcjy70q3ldg90sl";
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
      libX11 xproto inputproto libXt libXmu libXext xextproto
      libXinerama libXrandr randrproto libXtst libXfixes fixesproto
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
      ffmpeg
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
      substituteInPlace xbmc/linux/LinuxTimezone.cpp \
        --replace 'usr/share/zoneinfo' 'etc/zoneinfo'
    '';

    preConfigure = ''
      cd project/cmake
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
      maintainers = with maintainers; [ domenkozar titanous edwtjo peterhoeg ];
    };
}
