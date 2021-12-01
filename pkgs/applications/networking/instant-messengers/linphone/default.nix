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
, ffmpeg
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
, minizip2
, mkDerivation
, openldap
, ortp
, pango
, pkg-config
, qtbase
, qtgraphicaleffects
, qtquickcontrols2
, qttranslations
, readline
, speex
, sqlite

, udev
, zlib
}:

mkDerivation rec {
  pname = "linphone-desktop";
  version = "4.2.5";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1gq4l9p21rbrcksa7fbkzn9fzbbynqmn6ni6lhnvzk359sb1xvbz";
  };

  patches = [
    ./do-not-build-linphone-sdk.patch
    ./remove-bc_compute_full_version-usage.patch
  ];

  # See: https://gitlab.linphone.org/BC/public/linphone-desktop/issues/21
  postPatch = ''
    echo "project(linphoneqt VERSION ${version})" >linphone-app/linphoneqt_version.cmake
    substituteInPlace linphone-app/src/app/AppController.cpp \
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
    ffmpeg
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
    pkg-config
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
    cp linphone-app/linphone $out/bin/
    wrapProgram $out/bin/linphone \
      --set MEDIASTREAMER_PLUGINS_DIR \
            ${mediastreamer-openh264}/lib/mediastreamer/plugins
    mkdir -p $out/share/applications
    cp linphone-app/linphone.desktop $out/share/applications/
    cp -r ../linphone-app/assets/icons $out/share/
    mkdir -p $out/share/belr/grammars
    ln -s ${liblinphone}/share/belr/grammars/* $out/share/belr/grammars/
    mkdir -p $out/share/linphone
    ln -s ${liblinphone}/share/linphone/* $out/share/linphone/
  '';

  meta = with lib; {
    homepage = "https://www.linphone.org/";
    description = "Open source SIP phone for voice/video calls and instant messaging";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
