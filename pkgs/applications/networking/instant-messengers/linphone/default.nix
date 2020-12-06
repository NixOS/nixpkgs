{ bcg729
, bctoolbox
, bcunit
, belcard
, belle-sip
, belr
, bzrtp
, cairo
, cmake
, cyrus_sasl
, fetchFromGitLab
, fetchurl
, ffmpeg_3
, gdk-pixbuf
, glib
, gnused
, graphviz
, gtk2
, intltool
, lib
, libexosip
, liblinphone
, libmatroska
, libnotify
, libosip
, libsoup
, libupnp
, libX11
, libxml2
, makeWrapper
, mbedtls
, mediastreamer
, mediastreamer-openh264
, mkDerivation
, openldap
, ortp
, pango
, pkgconfig
, python
, qtbase
, qtgraphicaleffects
, qtquickcontrols2
, qttranslations
, readline
, speex
, sqlite
, stdenv
, udev
, zlib
  # For Minizip 2.2.7:
, fetchFromGitHub
, libbsd
}:
let
  # Linphone Desktop requires Minizip 2.2.7. Nixpkgs contains a very old version
  # from the time when it was part of zlib. The most recent release of Minizip
  # is currently 2.9.2 but Linphone Desktop didn't work with that. So, even if
  # we added most recent Minizip version to nixpkgs, probably Minizip 2.2.7 is
  # only needed here and we shouldn't add this semi-old version to
  # all-packages.nix. Therefore, just define it here locally.
  minizip2 = stdenv.mkDerivation rec {
    pname = "minizip";
    version = "2.2.7";

    disabled = stdenv.isAarch32;

    src = fetchFromGitHub {
      owner = "nmoinvaz";
      repo = pname;
      rev = version;
      sha256 = "1a88v1gjlflsd17mlrgxh420rpa38q0d17yh9q8j1zzqfrd1azch";
    };

    nativeBuildInputs = [ cmake pkgconfig ];

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=YES"
    ];

    buildInputs = [
      zlib
      libbsd # required in 2.2.7 but not in 2.9.2?
    ];

    meta = with stdenv.lib; {
      description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
      homepage = "https://github.com/nmoinvaz/minizip";
      license = licenses.zlib;
      platforms = platforms.unix;
    };
  };
in
mkDerivation rec {
  pname = "linphone-desktop";
  # Latest release is 4.1.1 old and doesn't build with the latest releases of
  # some of the dependencies so let's use the latest commit.
  version = "unstable-2020-03-06";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "971997e162558d37051f89c9c34bbc240135f704";
    sha256 = "02ji4r8bpcm2kyisn9d3054m026l33g2574i1ag1cmb2dz2p8i1c";
  };

  # Without this patch, the build fails with:
  #
  #   No rule to make target
  #   'minizip_OUTPUT/nix/store/...linphone-desktop.../lib/libminizip.so',
  #
  # So, the makefile tries to use a full absolute path to the library but does
  # it incorrectly. As we have installed Minizip properly, it's sufficient to
  # just use "minizip" and the library is found automatically. If this patched
  # target_link_libraries line was removed entirely, the build would fail at the
  # very end when linking minizip.
  patches = [
    ./fix_minizip_linking.patch
  ];

  # See: https://gitlab.linphone.org/BC/public/linphone-desktop/issues/21
  postPatch = ''
    substituteInPlace src/app/AppController.cpp \
      --replace "LINPHONE_QT_GIT_VERSION" "\"${version}\""
  '';

  # TODO: After linphone-desktop and liblinphone split into separate packages,
  # there might be some build inputs here that aren't needed for
  # linphone-desktop.
  buildInputs = [
    bcg729
    bctoolbox
    belcard
    belle-sip
    belr
    bzrtp
    cairo
    cyrus_sasl
    ffmpeg_3
    gdk-pixbuf
    glib
    gtk2
    libX11
    libexosip
    liblinphone
    libmatroska
    libnotify
    libosip
    libsoup
    libupnp
    libxml2
    mbedtls
    mediastreamer
    mediastreamer-openh264
    minizip2
    openldap
    ortp
    pango
    qtbase
    qtgraphicaleffects
    qtquickcontrols2
    qttranslations
    readline
    speex
    sqlite
    udev
    zlib
  ];

  nativeBuildInputs = [
    bcunit
    cmake
    gnused
    graphviz
    intltool
    makeWrapper
    pkgconfig
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DMINIZIP_INCLUDE_DIRS=${minizip2}/include"
    "-DMINIZIP_LIBRARIES=minizip"
  ];

  # The default install phase fails because the paths are somehow messed up in
  # the makefiles. The errors were like:
  #
  #   CMake Error at cmake_builder/linphone_package/cmake_install.cmake:49 (file):
  #     file INSTALL cannot find
  #     "/build/linphone-desktop-.../build/linphone-sdk/desktop//nix/store/.../bin":
  #     No such file or directory.
  #
  # If someone is able to figure out how to fix that, great. For now, just
  # trying to pick all the relevant files to the output.
  #
  # Also, the exec path in linphone.desktop file remains invalid, pointing to
  # the build directory, after the whole nix build process. So, let's use sed to
  # manually fix that path.
  #
  # In order to find mediastreamer plugins, mediastreamer package was patched to
  # support an environment variable pointing to the plugin directory. Set that
  # environment variable by wrapping the Linphone executable.
  #
  # Also, some grammar files needed to be copied too from some dependencies. I
  # suppose if one define a dependency in such a way that its share directory is
  # found, then this copying would be unnecessary. These missing grammar files
  # were discovered when linphone crashed at startup and it was run with
  # --verbose flag. Instead of actually copying these files, create symlinks.
  #
  # It is quite likely that there are some other files still missing and
  # Linphone will randomly crash when it tries to access those files. Then,
  # those just need to be copied manually below.
  installPhase = ''
    mkdir -p $out/bin
    cp linphone $out/bin/
    wrapProgram $out/bin/linphone \
      --set MEDIASTREAMER_PLUGINS_DIR \
            ${mediastreamer-openh264}/lib/mediastreamer/plugins
    mkdir -p $out/share/applications
    sed -i "s@/build/.*/OUTPUT/bin@$out/bin@" linphone.desktop
    cp linphone.desktop $out/share/applications/
    cp -r ../assets/icons $out/share/
    mkdir -p $out/share/belr/grammars
    ln -s ${liblinphone}/share/belr/grammars/* $out/share/belr/grammars/
    mkdir -p $out/share/linphone
    ln -s ${liblinphone}/share/linphone/* $out/share/linphone/
  '';

  meta = with lib; {
    homepage = "https://www.linphone.org/";
    description = "Open source SIP phone for voice/video calls and instant messaging";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
