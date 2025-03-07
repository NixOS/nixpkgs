{ stdenv, lib, fetchFromGitHub, fetchzip
, autoconf, automake, libtool, makeWrapper
, pkg-config, cmake, yasm, python3Packages
, libxcrypt, libgcrypt, libgpg-error, libunistring
, boost, avahi, lame
, gettext, pcre-cpp, yajl, fribidi, which
, openssl, gperf, tinyxml2, tinyxml-2, taglib, libssh, jre_headless
, gtest, ncurses, spdlog
, libxml2, systemd
, alsa-lib, libGLU, libGL, ffmpeg, fontconfig, freetype, ftgl
, libjpeg, libpng, libtiff
, libmpeg2, libsamplerate, libmad
, libogg, libvorbis, flac, libxslt
, lzo, libcdio, libmodplug, libass, libbluray, libudfread
, sqlite, libmysqlclient, nasm, gnutls, libva, libdrm
, curl, bzip2, zip, unzip, mesa-demos
, libcec, libcec_platform, dcadec, libuuid
, libcrossguid, libmicrohttpd
, bluez, doxygen, giflib, glib, harfbuzz, lcms2, libidn2, libpthreadstubs, libtasn1
, libplist, p11-kit, zlib, flatbuffers, fstrcmp, rapidjson
, lirc, mesa-gl-headers
, x11Support ? true, libX11, xorgproto, libXt, libXmu, libXext, libXinerama, libXrandr, libXtst, libXfixes, xdpyinfo, libXdmcp
, dbusSupport ? true, dbus
, joystickSupport ? true, cwiid
, nfsSupport ? true, libnfs
, pulseSupport ? true, libpulseaudio
, pipewireSupport ? true, pipewire
, rtmpSupport ? true, rtmpdump
, sambaSupport ? true, samba
, udevSupport ? true, udev
, opticalSupport ? true
, usbSupport  ? false, libusb-compat-0_1
, vdpauSupport ? true, libvdpau
, waylandSupport ? false, wayland, wayland-protocols
, waylandpp ?  null, libxkbcommon
, gbmSupport ? false, libgbm, libinput, libdisplay-info
, buildPackages
}:

assert usbSupport -> !udevSupport; # libusb-compat-0_1 won't be used if udev is available
assert gbmSupport || waylandSupport || x11Support;

let
  # see https://github.com/xbmc/xbmc/blob/${kodiVersion}-${rel}/tools/depends/target/ to get suggested versions for all dependencies

  # We can build these externally but FindLibDvd.cmake forces us to build it
  # them, so we currently just use them for the src.
  libdvdcss = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdcss";
    rev = "1.4.3-Next-Nexus-Alpha2-2";
    sha256 = "sha256-CJMGH50mNAkovccNcol5ArF3zUnZKfbVB9EXyQgu5k4=";
  };

  libdvdnav = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdnav";
    rev = "6.1.1-Next-Nexus-Alpha2-2";
    sha256 = "sha256-m8SCjOokVbwJ7eVfYKHap1pQjVbI+BXaoxhGZQIg0+k=";
  };

  libdvdread = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdread";
    rev = "6.1.3-Next-Nexus-Alpha2-2";
    sha256 = "sha256-AphBQhXud+a6wm52zjzC5biz53NnqWdgpL2QDt2ZuXc=";
  };

  groovy = fetchzip {
    url = "mirror://apache/groovy/4.0.16/distribution/apache-groovy-binary-4.0.16.zip";
    sha256 = "sha256-OfZBiMVrhw6VqHRHCSC7ZV3FiZ26n4+F8hsskk+L6yU=";
  };

  apache_commons_lang = fetchzip {
    url = "mirror://apache/commons/lang/binaries/commons-lang3-3.14.0-bin.zip";
    sha512 = "sha512-eKF1IQ6PDtifb4pMHWQ2SYHIh0HbMi3qpc92lfbOo3uSsFJVR3n7JD0AdzrG17tLJQA4z5PGDhwyYw0rLeLsXw==";
  };

  apache_commons_text = fetchzip {
    url = "mirror://apache/commons/text/binaries/commons-text-1.11.0-bin.zip";
    sha512 = "sha512-P2IvnrHSYRF70LllTMI8aev43h2oe8lq6rrMYw450PEhEa7OuuCjh1Krnc/A4OqENUcidVAAX5dK1RAsZHh8Dg==";
  };

  kodi_platforms = lib.optional gbmSupport "gbm"
    ++ lib.optional waylandSupport "wayland"
    ++ lib.optional x11Support "x11";

in stdenv.mkDerivation (finalAttrs: {
    pname = "kodi";
    version = "21.2";
    kodiReleaseName = "Omega";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo  = "xbmc";
      rev   = "${finalAttrs.version}-${finalAttrs.kodiReleaseName}";
      hash  = "sha256-RdTJcq6FPerQx05dU3r8iyaorT4L7162hg5RdywsA88=";
    };

    # make  derivations declared in the let binding available here, so
    # they can be overridden
    inherit libdvdcss libdvdnav libdvdread groovy
            apache_commons_lang apache_commons_text;

    buildInputs = [
      gnutls libidn2 libtasn1 nasm p11-kit
      libxml2 python3Packages.python
      boost libmicrohttpd
      gettext pcre-cpp yajl fribidi libva libdrm
      openssl gperf tinyxml2 tinyxml-2 taglib libssh
      gtest ncurses spdlog
      alsa-lib libGL libGLU fontconfig freetype ftgl
      libjpeg libpng libtiff
      libmpeg2 libsamplerate libmad
      libogg libvorbis flac libxslt systemd
      lzo libcdio libmodplug libass libbluray libudfread
      sqlite libmysqlclient avahi lame
      curl bzip2 zip unzip mesa-demos
      libcec libcec_platform dcadec libuuid
      libxcrypt libgcrypt libgpg-error libunistring
      libcrossguid libplist
      bluez giflib glib harfbuzz lcms2 libpthreadstubs
      ffmpeg flatbuffers fstrcmp rapidjson
      lirc
      mesa-gl-headers
    ]
    ++ lib.optionals x11Support [
      libX11 xorgproto libXt libXmu libXext.dev libXdmcp
      libXinerama libXrandr.dev libXtst libXfixes
    ]
    ++ lib.optional  dbusSupport     dbus
    ++ lib.optional  joystickSupport cwiid
    ++ lib.optional  nfsSupport      libnfs
    ++ lib.optional  pulseSupport    libpulseaudio
    ++ lib.optional  pipewireSupport pipewire
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
    ++ lib.optionals gbmSupport [
      libxkbcommon.dev
      libgbm
      libinput.dev
      libdisplay-info
    ];

    nativeBuildInputs = [
      cmake
      doxygen
      makeWrapper
      which
      pkg-config
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
      "-Dlibdvdcss_URL=${finalAttrs.libdvdcss}"
      "-Dlibdvdnav_URL=${finalAttrs.libdvdnav}"
      "-Dlibdvdread_URL=${finalAttrs.libdvdread}"
      "-Dgroovy_SOURCE_DIR=${finalAttrs.groovy}"
      "-Dapache-commons-lang_SOURCE_DIR=${finalAttrs.apache_commons_lang}"
      "-Dapache-commons-text_SOURCE_DIR=${finalAttrs.apache_commons_text}"
      # Upstream derives this from the git HEADs hash and date.
      # LibreElec (minimal distro for kodi) uses the equivalent to this.
      "-DGIT_VERSION=${finalAttrs.version}-${finalAttrs.kodiReleaseName}"
      "-DENABLE_EVENTCLIENTS=ON"
      "-DENABLE_INTERNAL_CROSSGUID=OFF"
      "-DENABLE_INTERNAL_RapidJSON=OFF"
      "-DENABLE_OPTICAL=${if opticalSupport then "ON" else "OFF"}"
      "-DENABLE_VDPAU=${if vdpauSupport then "ON" else "OFF"}"
      "-DLIRC_DEVICE=/run/lirc/lircd"
      "-DSWIG_EXECUTABLE=${buildPackages.swig}/bin/swig"
      "-DFLATBUFFERS_FLATC_EXECUTABLE=${buildPackages.flatbuffers}/bin/flatc"
      "-DPYTHON_EXECUTABLE=${buildPackages.python3Packages.python}/bin/python"
      "-DPYTHON_LIB_PATH=${python3Packages.python.sitePackages}"
      # When wrapped KODI_HOME will likely contain symlinks to static assets
      # that Kodi's built in webserver will cautiously refuse to serve up
      # (because their realpaths are outside of KODI_HOME and the other
      # whitelisted directories). This adds the entire nix store to the Kodi
      # webserver whitelist to avoid this problem.
      "-DKODI_WEBSERVER_EXTRA_WHITELIST=${builtins.storeDir}"
    ] ++ lib.optionals waylandSupport [
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
      CXX=$CXX_FOR_BUILD LD=ld make -C tools/depends/native/JsonSchemaBuilder
      appendToVar cmakeFlags "-DWITH_JSONSCHEMABUILDER=$PWD/tools/depends/native/JsonSchemaBuilder/bin"

      CXX=$CXX_FOR_BUILD LD=ld make EXTRA_CONFIGURE= -C tools/depends/native/TexturePacker
      appendToVar cmakeFlags "-DWITH_TEXTUREPACKER=$PWD/tools/depends/native/TexturePacker/bin"
    '';

    postInstall = ''
      # TODO: figure out which binaries should be wrapped this way and which shouldn't
      for p in $(ls --ignore=kodi-send $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH ":" "${lib.makeBinPath ([ python3Packages.python mesa-demos ]
            ++ lib.optional x11Support xdpyinfo ++ lib.optional sambaSupport samba)}" \
          --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath
              ([ curl systemd libmad libcec libcec_platform libass ]
                 ++ lib.optional vdpauSupport libvdpau
                 ++ lib.optional nfsSupport libnfs
                 ++ lib.optional rtmpSupport rtmpdump)}"
      done

      wrapProgram $out/bin/kodi-send \
        --prefix PYTHONPATH : $out/${python3Packages.python.sitePackages}

      substituteInPlace $out/share/xsessions/kodi.desktop \
        --replace kodi-standalone $out/bin/kodi-standalone
    '';

    doInstallCheck = true;

    installCheckPhase = "$out/bin/kodi --version";

    passthru = {
      pythonPackages = python3Packages;
      ffmpeg = ffmpeg;
      kodi = finalAttrs.finalPackage;
    };

    meta = with lib; {
      description = "Media center";
      homepage    = "https://kodi.tv/";
      license     = licenses.gpl2Plus;
      platforms   = platforms.linux;
      maintainers = teams.kodi.members;
      mainProgram = "kodi";
    };
})
