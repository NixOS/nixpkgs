{ bctoolbox
, belcard
, belle-sip
, belr
, cmake
, fetchFromGitLab
, lib
, liblinphone
, mediastreamer
, mediastreamer-openh264
, minizip-ng
, mkDerivation
, qtgraphicaleffects
, qtmultimedia
, qtquickcontrols2
, qttools
}:

# How to update Linphone? (The Qt desktop app)
#
# Belledonne Communications (BC), the company making Linphone, has split the
# project into several sub-projects that they maintain, plus some third-party
# dependencies that they also extend with commits of their own, specific to
# Linphone and not (yet?) upstreamed.
#
# All of this is organised in a Software Development Kit (SDK) meta-repository
# with git submodules to pin all those repositories into a coherent whole.
#
# The Linphone Qt desktop app uses this SDK as submodule as well.
#
# So, in order to update the desktop app to a new release, one has to follow
# the submodule chain and update the corresponding derivations here, in nixpkgs,
# with the corresponding version number (or commit hash)

mkDerivation rec {
  pname = "linphone-desktop";
  version = "5.1.2";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    hash = "sha256-Pu2tGKe3C1uR4lzXkC5sJFu8iJBqF76UfWJXYjPwBkc=";
  };

  patches = [
    ./do-not-build-linphone-sdk.patch
    ./remove-bc_compute_full_version-usage.patch
    ./no-store-path-in-autostart.patch
    ./reset-output-dirs.patch
  ];

  # See: https://gitlab.linphone.org/BC/public/linphone-desktop/issues/21
  postPatch = ''
    echo "project(linphoneqt VERSION ${version})" >linphone-app/linphoneqt_version.cmake
    substituteInPlace linphone-app/src/app/AppController.cpp \
      --replace "APPLICATION_SEMVER" "\"${version}\""
    substituteInPlace CMakeLists.txt \
      --subst-var out
  '';

  # TODO: After linphone-desktop and liblinphone split into separate packages,
  # there might be some build inputs here that aren't needed for
  # linphone-desktop.
  buildInputs = [
    # Made by BC
    bctoolbox
    belcard
    belle-sip
    belr
    liblinphone
    mediastreamer
    mediastreamer-openh264

    minizip-ng
    qtgraphicaleffects
    qtmultimedia
    qtquickcontrols2
  ];

  nativeBuildInputs = [
    cmake
    qttools
  ];

  cmakeFlags = [
    "-DMINIZIP_INCLUDE_DIRS=${minizip-ng}/include"
    "-DMINIZIP_LIBRARIES=minizip"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # Requires EQt5Keychain
    "-DENABLE_QT_KEYCHAIN=OFF"

    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  preInstall = ''
    mkdir -p $out/share/linphone
    mkdir -p $out/share/sounds/linphone
  '';

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
  postInstall = ''
    mkdir -p $out/lib/mediastreamer/plugins
    ln -s ${mediastreamer-openh264}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/
    ln -s ${mediastreamer}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/

    mkdir -p $out/share/belr/grammars
    ln -s ${liblinphone}/share/belr/grammars/* $out/share/belr/grammars/
    ln -s ${belle-sip}/share/belr/grammars/* $out/share/belr/grammars/

    wrapProgram $out/bin/linphone \
      --set MEDIASTREAMER_PLUGINS_DIR $out/lib/mediastreamer/plugins
  '';

  meta = with lib; {
    homepage = "https://www.linphone.org/";
    description = "Open source SIP phone for voice/video calls and instant messaging";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
