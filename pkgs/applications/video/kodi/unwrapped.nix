{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, makeWrapper
, pkg-config, cmake, gnumake, yasm, python3Packages
, libgcrypt, libgpg-error, libunistring
, boost, avahi, lame
, gettext, pcre-cpp, yajl, fribidi, which
, openssl, gperf, tinyxml2, taglib, libssh, swig, jre_headless
, gtest, ncurses, spdlog
, libxml2, systemd
, alsa-lib, libGLU, libGL, fontconfig, freetype, ftgl
, libjpeg, libpng, libtiff
, libmpeg2, libsamplerate, libmad
, libogg, libvorbis, flac, libxslt
, lzo, libcdio, libmodplug, libass, libbluray
, sqlite, libmysqlclient, nasm, gnutls, libva, libdrm
, curl, bzip2, zip, unzip, glxinfo
, libcec, libcec_platform, dcadec, libuuid
, libcrossguid, libmicrohttpd
, bluez, doxygen, giflib, glib, harfbuzz, lcms2, libidn, libpthreadstubs, libtasn1
, libplist, p11-kit, zlib, flatbuffers, fmt, fstrcmp, rapidjson
, lirc
, x11Support ? true, libX11, xorgproto, libXt, libXmu, libXext, libXinerama, libXrandr, libXtst, libXfixes, xdpyinfo, libXdmcp
, dbusSupport ? true, dbus
, joystickSupport ? true, cwiid
, nfsSupport ? true, libnfs
, pulseSupport ? true, libpulseaudio
, rtmpSupport ? true, rtmpdump
, sambaSupport ? true, samba
, udevSupport ? true, udev
, usbSupport  ? false, libusb-compat-0_1
, vdpauSupport ? true, libvdpau
, waylandSupport ? false, wayland, wayland-protocols
, waylandpp ?  null, libxkbcommon
, gbmSupport ? false, mesa, libinput
, buildPackages
}:

assert usbSupport -> !udevSupport; # libusb-compat-0_1 won't be used if udev is avaliable
assert gbmSupport || waylandSupport || x11Support;

let
  kodiReleaseDate = "20211024";
  kodiVersion = "19.3";
  rel = "Matrix";

  kodi_src = fetchFromGitHub {
    owner  = "xbmc";
    repo   = "xbmc";
    rev    = "${kodiVersion}-${rel}";
    sha256 = "02bnknk87zzv9j6b6k9c0xx47q2gh399j6v25rm94g7rhzf8phbw";
  };

  ffmpeg = stdenv.mkDerivation rec {
    pname = "kodi-ffmpeg";
    version = "4.3.2";
    src = fetchFromGitHub {
      owner   = "xbmc";
      repo    = "FFmpeg";
      rev     = "${version}-${rel}-${kodiVersion}";
      sha256  = "14s215sgc93ds1mrdbkgb7fvy94lpgv2ldricyxzis0gbzqfgs4f";
    };
    preConfigure = ''
      cp ${kodi_src}/tools/depends/target/ffmpeg/{CMakeLists.txt,*.cmake} .
      sed -i 's/ --cpu=''${CPU}//' CMakeLists.txt
      sed -i 's/--strip=''${CMAKE_STRIP}/--strip=''${CMAKE_STRIP} --ranlib=''${CMAKE_RANLIB}/' CMakeLists.txt
    '';
    cmakeFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "-DCROSSCOMPILING=ON"
      "-DCPU=${stdenv.hostPlatform.parsed.cpu.name}"
      "-DOS=${stdenv.hostPlatform.parsed.kernel.name}"
      "-DPKG_CONFIG_EXECUTABLE=pkg-config"
    ];
    buildInputs = [ libidn libtasn1 p11-kit zlib libva ]
      ++ lib.optional vdpauSupport libvdpau;
    nativeBuildInputs = [ cmake nasm pkg-config gnutls ];
  };

  # We can build these externally but FindLibDvd.cmake forces us to build it
  # them, so we currently just use them for the src.
  libdvdcss = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdcss";
    rev = "1.4.2-Leia-Beta-5";
    sha256 = "0j41ydzx0imaix069s3z07xqw9q95k7llh06fc27dcn6f7b8ydyl";
  };

  libdvdnav = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdnav";
    rev = "6.0.0-Leia-Alpha-3";
    sha256 = "0qwlf4lgahxqxk1r2pzl866mi03pbp7l1fc0rk522sc0ak2s9jhb";
  };

  libdvdread = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdread";
    rev = "6.0.0-Leia-Alpha-3";
    sha256 = "1xxn01mhkdnp10cqdr357wx77vyzfb5glqpqyg8m0skyi75aii59";
  };

  kodi_platforms = lib.optional gbmSupport "gbm"
    ++ lib.optional waylandSupport "wayland"
    ++ lib.optional x11Support "x11";

in stdenv.mkDerivation {
    pname = "kodi";
    version = kodiVersion;

    src = kodi_src;

    buildInputs = [
      gnutls libidn libtasn1 nasm p11-kit
      libxml2 python3Packages.python
      boost libmicrohttpd
      gettext pcre-cpp yajl fribidi libva libdrm
      openssl gperf tinyxml2 taglib libssh
      gtest ncurses spdlog
      alsa-lib libGL libGLU fontconfig freetype ftgl
      libjpeg libpng libtiff
      libmpeg2 libsamplerate libmad
      libogg libvorbis flac libxslt systemd
      lzo libcdio libmodplug libass libbluray
      sqlite libmysqlclient avahi lame
      curl bzip2 zip unzip glxinfo
      libcec libcec_platform dcadec libuuid
      libgcrypt libgpg-error libunistring
      libcrossguid libplist
      bluez giflib glib harfbuzz lcms2 libpthreadstubs
      ffmpeg flatbuffers fmt fstrcmp rapidjson
      lirc
      mesa # for libEGL
    ]
    ++ lib.optional x11Support [
      libX11 xorgproto libXt libXmu libXext.dev libXdmcp
      libXinerama libXrandr.dev libXtst libXfixes
    ]
    ++ lib.optional  dbusSupport     dbus
    ++ lib.optional  joystickSupport cwiid
    ++ lib.optional  nfsSupport      libnfs
    ++ lib.optional  pulseSupport    libpulseaudio
    ++ lib.optional  rtmpSupport     rtmpdump
    ++ lib.optional  sambaSupport    samba
    ++ lib.optional  udevSupport     udev
    ++ lib.optional  usbSupport      libusb-compat-0_1
    ++ lib.optional  vdpauSupport    libvdpau
    ++ lib.optionals waylandSupport [
      wayland
      waylandpp.dev
      wayland-protocols
      # Not sure why ".dev" is needed here, but CMake doesn't find libxkbcommon otherwise
      libxkbcommon.dev
    ]
    ++ lib.optional gbmSupport [
      libxkbcommon.dev
      mesa.dev
      libinput.dev
    ];

    nativeBuildInputs = [
      cmake
      doxygen
      makeWrapper
      which
      pkg-config gnumake
      autoconf automake libtool # still needed for some components. Check if that is the case with 19.0
      jre_headless yasm gettext python3Packages.python flatbuffers

      # for TexturePacker
      giflib zlib libpng libjpeg lzo
    ] ++ lib.optionals waylandSupport [ wayland-protocols waylandpp.bin ];

    depsBuildBuild = [
      buildPackages.stdenv.cc
    ];

    cmakeFlags = [
      "-DAPP_RENDER_SYSTEM=${if gbmSupport then "gles" else "gl"}"
      "-Dlibdvdcss_URL=${libdvdcss}"
      "-Dlibdvdnav_URL=${libdvdnav}"
      "-Dlibdvdread_URL=${libdvdread}"
      "-DGIT_VERSION=${kodiReleaseDate}"
      "-DENABLE_EVENTCLIENTS=ON"
      "-DENABLE_INTERNAL_CROSSGUID=OFF"
      "-DENABLE_OPTICAL=ON"
      "-DLIRC_DEVICE=/run/lirc/lircd"
      "-DSWIG_EXECUTABLE=${buildPackages.swig}/bin/swig"
      "-DFLATBUFFERS_FLATC_EXECUTABLE=${buildPackages.flatbuffers}/bin/flatc"
      "-DPYTHON_EXECUTABLE=${buildPackages.python3Packages.python}/bin/python"
    ] ++ lib.optional waylandSupport [
      "-DWAYLANDPP_SCANNER=${buildPackages.waylandpp}/bin/wayland-scanner++"
    ];

    # 14 tests fail but the biggest issue is that every test takes 30 seconds -
    # I'm guessing there is a thing waiting to time out
    doCheck = false;

    preConfigure = ''
      cmakeFlagsArray+=("-DCORE_PLATFORM_NAME=${lib.concatStringsSep " " kodi_platforms}")
    '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      # Need these tools on the build system when cross compiling,
      # hacky, but have found no other way.
      CXX=${stdenv.cc.targetPrefix}c++ LD=ld make -C tools/depends/native/JsonSchemaBuilder
      cmakeFlags+=" -DWITH_JSONSCHEMABUILDER=$PWD/tools/depends/native/JsonSchemaBuilder/bin"

      CXX=${stdenv.cc.targetPrefix}c++ LD=ld make EXTRA_CONFIGURE= -C tools/depends/native/TexturePacker
      cmakeFlags+=" -DWITH_TEXTUREPACKER=$PWD/tools/depends/native/TexturePacker/bin"
    '';

    postPatch = ''
      substituteInPlace xbmc/platform/posix/PosixTimezone.cpp \
        --replace 'usr/share/zoneinfo' 'etc/zoneinfo'
    '';

    postInstall = ''
      for p in $(ls $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH ":" "${lib.makeBinPath ([ python3Packages.python glxinfo ]
            ++ lib.optional x11Support xdpyinfo ++ lib.optional sambaSupport samba)}" \
          --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath
              ([ curl systemd libmad libvdpau libcec libcec_platform libass ]
                 ++ lib.optional nfsSupport libnfs
                 ++ lib.optional rtmpSupport rtmpdump)}"
      done

      substituteInPlace $out/share/xsessions/kodi.desktop \
        --replace kodi-standalone $out/bin/kodi-standalone
    '';

    doInstallCheck = true;

    installCheckPhase = "$out/bin/kodi --version";

    passthru = {
      pythonPackages = python3Packages;
      ffmpeg = ffmpeg;
    };

    meta = with lib; {
      description = "Media center";
      homepage    = "https://kodi.tv/";
      license     = licenses.gpl2Plus;
      platforms   = platforms.linux;
      maintainers = teams.kodi.members;
    };
}
