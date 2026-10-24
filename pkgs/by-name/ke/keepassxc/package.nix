{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,

  apple-sdk_15,
  asciidoctor,
  botan3,
  darwinMinVersionHook,
  keyutils,
  libxi,
  libxtst,
  libusb1,
  minizip,
  nix-update-script,
  pcsclite,
  pkg-config,
  qrencode,
  readline,
  wrapGAppsHook3,
  zlib,

  withKeePassBrowser ? true,
  withKeePassDocs ? true,
  withKeePassFDOSecrets ? stdenv.hostPlatform.isLinux,
  withKeePassMinimal ? false,
  withKeePassNetworking ? true,
  withKeePassSSHAgent ? true,
  withKeePassX11 ? true,

  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keepassxc";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    tag = finalAttrs.version;
    hash = "sha256-821zL+xnCsHU8VvxsJh2a2LRGstSIq3tWQbWBk8g4hc=";
  };

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-old-style-cast"
      "-Wno-error"
      "-D__BIG_ENDIAN__=${if stdenv.hostPlatform.isBigEndian then "1" else "0"}"
    ];
  };

  patches = [ ./darwin-remove-macdeployqt.patch ];

  # Upstream develops against a build of PCSC from Xcode.
  # The types are incompatible with nixpkgs pcsclite.
  # https://github.com/NixOS/nixpkgs/issues/520227
  postPatch = ''
    substituteInPlace src/keys/drivers/YubiKeyInterfacePCSC.cpp \
      --replace-fail "typedef uint32_t RETVAL;" "typedef int32_t RETVAL;"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "KEEPASSXC_BUILD_TYPE" "Release")
    (lib.cmakeBool "WITH_GUI_TESTS" true)
    (lib.cmakeBool "KPXC_FEATURE_UPDATES" false)
    (lib.cmakeBool "WITH_X11" withKeePassX11)
    (lib.cmakeBool "KPXC_MINIMAL" withKeePassMinimal)
    (lib.cmakeBool "KPXC_FEATURE_DOCS" withKeePassDocs)
    (lib.cmakeBool "KPXC_FEATURE_BROWSER" withKeePassBrowser)
    (lib.cmakeBool "KPXC_FEATURE_NETWORK" withKeePassNetworking)
    (lib.cmakeBool "KPXC_FEATURE_SSHAGENT" withKeePassSSHAgent)
    (lib.cmakeBool "KPXC_FEATURE_FDOSECRETS" withKeePassFDOSecrets)
  ];

  doCheck = true;
  checkPhase =
    let
      disabledTests = lib.concatStringsSep "|" (
        [
          # flaky
          "testcli"
          "testgui"
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # QWidget: Cannot create a QWidget without QApplication
          "testautotype"

          # FAIL!  : TestDatabase::testExternallyModified() Compared values are not the same
          #   Actual   (((spyFileChanged.count()))): 0
          #   Expected (1)                         : 1
          #   Loc: [/tmp/nix-build-keepassxc-2.7.10.drv-2/source/tests/TestDatabase.cpp(288)]
          "testdatabase"
        ]
      );
    in
    ''
      runHook preCheck

      export LC_ALL="en_US.UTF-8"
      export QT_QPA_PLATFORM=offscreen

      make test ARGS+="-E '${disabledTests}' --output-on-failure"

      runHook postCheck
    '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    qt6.qttools
    pkg-config
  ]
  ++ lib.optional withKeePassDocs asciidoctor
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) wrapGAppsHook3;

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapQtApp "$out/Applications/KeePassXC.app/Contents/MacOS/KeePassXC"
  '';

  postInstall = lib.concatLines [
    (lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/bin"
      for program in keepassxc-cli keepassxc-proxy; do
        ln -s "$out/Applications/KeePassXC.app/Contents/MacOS/$program" "$out/bin/$program"
      done
    '')

    # See https://github.com/keepassxreboot/keepassxc/blob/cd7a53abbbb81e468efb33eb56eefc12739969b8/src/browser/NativeMessageInstaller.cpp#L317
    # See https://github.com/keepassxreboot/keepassxc/blob/cd7a53abbbb81e468efb33eb56eefc12739969b8/utils/keepassxc-snap-helper.sh#L48-L58
    (lib.optionalString withKeePassBrowser ''
      mkdir -p "$out/lib/mozilla/native-messaging-hosts"
      substituteAll "${./firefox-native-messaging-host.json}" "$out/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"

      mkdir -p "$out/etc/chromium/native-messaging-hosts"
      substituteAll "${./chromium-native-messaging-host.json}" "$out/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
    '')
  ];

  buildInputs = [
    botan3
    libxi
    libxtst
    qt6.qtbase
    qt6.qtsvg
    minizip
    pcsclite
    qrencode
    readline
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    # ScreenCaptureKit, required by livekit, is only available on 12.3 and up:
    # https://developer.apple.com/documentation/screencapturekit
    (darwinMinVersionHook "12.3")
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    keyutils
    libusb1
  ];

  passthru = {
    tests = {
      inherit (nixosTests) keepassxc;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Offline password manager with many features";
    longDescription = ''
      A community fork of KeePassX, which is itself a port of KeePass Password Safe.
      The goal is to extend and improve KeePassX with new features and bugfixes,
      to provide a feature-rich, fully cross-platform and modern open-source password manager.
      Accessible via native cross-platform GUI, CLI, has browser integration
      using the KeePassXC Browser Extension (https://github.com/keepassxreboot/keepassxc-browser)
    '';
    homepage = "https://keepassxc.org/";
    donationPage = "https://keepassxc.org/donate/";
    changelog = "https://github.com/keepassxreboot/keepassxc/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "keepassxc";
    maintainers = with lib.maintainers; [
      sigmasquadron
      ryand56
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
