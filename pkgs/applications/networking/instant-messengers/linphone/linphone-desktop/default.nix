{
  bc-ispell,
  bc-soci,
  bctoolbox,
  belcard,
  belle-sip,
  belr,
  boost,
  cmake,
  doxygen,
  fetchFromGitLab,
  lib,
  liblinphone,
  lime,
  linphoneSdkVersion,
  mediastreamer2,
  minizip-ng,
  msopenh264,
  python3,
  python3Packages,
  qt6Packages,
  stdenv,
  symlinkJoin,
  xercesc,
  zxing-cpp,
}:
let
  grammars = symlinkJoin {
    name = "belr-grammars";
    paths =
      let
        grammarPackages = [
          belle-sip
          belcard
          liblinphone
        ];
      in
      map (e: "${e}/share/belr/grammars") grammarPackages;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linphone-desktop";
  version = "6.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "linphone-desktop";
    tag = finalAttrs.version;
    hash = "sha256-jCnovCFdPJExD0+ZLhU9np1R5uN+mPlSPi/Nb1aOD0U=";
  };

  patches = [
    ./do-not-override-install-prefix.patch
    ./do-not-manually-compute-sdk-version.patch
    ./always-install-desktop-files.patch

    # .mkv recordings are broken in NixOS and other distros (see
    # https://github.com/NixOS/nixpkgs/issues/219551), and simply changing the
    # file extension is enough to affect the chosen codec (wav makes more
    # sense for audio recordings anyway)
    ./record-in-wav-format.patch
  ];

  buildInputs = [
    # Made by BC
    bctoolbox
    belle-sip
    belr
    liblinphone
    mediastreamer2
    msopenh264
    lime
    bc-soci
    bc-ispell

    xercesc
    minizip-ng
    qt6Packages.qtbase
    qt6Packages.qtnetworkauth
    zxing-cpp
    boost

    python3Packages.pystache
    python3Packages.six
  ];

  nativeBuildInputs = [
    cmake
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
    python3
    doxygen
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DBUILD_SHARED_LIBS=ON"
    "-DMINIZIP_INCLUDE_DIRS=${minizip-ng}/include"
    "-DMINIZIP_LIBRARIES=minizip"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # Requires EQt5Keychain
    "-DENABLE_QT_KEYCHAIN=OFF"

    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DLINPHONEAPP_VERSION=${finalAttrs.version}"
    "-DLINPHONE_QT_ONLY=ON"
    "-DLINPHONEAPP_INSTALL_PREFIX=${placeholder "out"}"
    "-DLINPHONE_QML_DIR=${placeholder "out"}/${qt6Packages.qtbase.qtQmlPrefix}/ui"
    "-DLINPHONESDK_VERSION=${linphoneSdkVersion}"
    "-DENABLE_APP_PACKAGE_ROOTCA=OFF"

    # normally set by the custom find modules, which we have disabled
    "-DLibLinphone_TARGET=liblinphone"
    "-DLinphoneCxx_TARGET=liblinphone++"
    "-DISpell_SOURCE_DIR=${bc-ispell.src}"

    # used in Linphone's CMakeLists.txt
    "-DLINPHONEAPP_VERSION=${finalAttrs.version}"
  ];

  # error: invalid conversion from 'int' to 'const char*'
  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  preConfigure = ''
    # custom "find" modules are causing issues during build,
    # as they are blinding cmake to nix dependencies
    rm -rf cmake/Modules
  '';

  preInstall = ''
    mkdir -p $out/share/linphone
    mkdir -p $out/share/sounds/linphone
    mkdir -p $out/share/belr
  '';

  # In order to find mediastreamer plugins, mediastreamer package was patched to
  # support an environment variable pointing to the plugin directory. Set that
  # environment variable by wrapping the Linphone executable.
  #
  # It is quite likely that there are some other files still missing and
  # Linphone will randomly crash when it tries to access those files. Then,
  # those just need to be linked manually below.
  postInstall = ''
    mkdir -p $out/lib/mediastreamer/plugins
    ln -s ${msopenh264}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/
    ln -s ${mediastreamer2}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/
    ln -s ${grammars} $out/share/belr/grammars

    wrapProgram $out/bin/linphone \
      --unset QML2_IMPORT_PATH \
      --set MEDIASTREAMER_PLUGINS_DIR $out/lib/mediastreamer/plugins
  '';

  meta = {
    homepage = "https://www.linphone.org/";
    description = "Open source SIP phone for voice/video calls and instant messaging";
    mainProgram = "linphone";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jluttine
      naxdy
    ];
  };
})
