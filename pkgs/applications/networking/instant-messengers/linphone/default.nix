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
, minizip2
, mkDerivation
, qtgraphicaleffects
, qtquickcontrols2
, qttranslations
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
  version = "4.4.9";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-xvKkFMZ7rUyEjnQK7rBkrzO8fhfHjpQ1DHQBUlizZ+o=";
  };

  patches = [
    ./do-not-build-linphone-sdk.patch
    ./remove-bc_compute_full_version-usage.patch
    ./no-store-path-in-autostart.patch
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
    # Made by BC
    bctoolbox
    belcard
    belle-sip
    belr
    liblinphone
    mediastreamer
    mediastreamer-openh264

    minizip2
    qtgraphicaleffects
    qtquickcontrols2
    qttranslations
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DMINIZIP_INCLUDE_DIRS=${minizip2}/include"
    "-DMINIZIP_LIBRARIES=minizip"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
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
    mkdir -p $out/bin $out/lib
    cp linphone-app/linphone $out/bin/
    cp linphone-app/libapp-plugin.so $out/lib/
    mkdir -p $out/lib/mediastreamer/plugins
    ln -s ${mediastreamer-openh264}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/
    ln -s ${mediastreamer}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/
    wrapProgram $out/bin/linphone \
      --set MEDIASTREAMER_PLUGINS_DIR \
            $out/lib/mediastreamer/plugins
    mkdir -p $out/share/applications
    cp linphone-app/linphone.desktop $out/share/applications/
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ../linphone-app/assets/images/linphone_logo.svg $out/share/icons/hicolor/scalable/apps/linphone.svg
    mkdir -p $out/share/belr/grammars
    ln -s ${liblinphone}/share/belr/grammars/* $out/share/belr/grammars/
    ln -s ${belle-sip}/share/belr/grammars/* $out/share/belr/grammars/
    mkdir -p $out/share/linphone
    ln -s ${liblinphone}/share/linphone/* $out/share/linphone/
    ln -s ${liblinphone}/share/sounds $out/share/sounds
  '';

  meta = with lib; {
    homepage = "https://www.linphone.org/";
    description = "Open source SIP phone for voice/video calls and instant messaging";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
