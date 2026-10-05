{
  lib,
  stdenv,
  fetchFromCodeberg,

  appstream,
  asciidoctor,
  botan3,
  cmake,
  libargon2,
  libusb1,
  libxtst,
  minizip,
  nix-update-script,
  pcsclite,
  pkg-config,
  qrencode,
  qt6Packages,
  readline,
  wrapGAppsHook3,
  zlib,
  zxcvbn-c,

  withChiPassBrowser ? true,
  withChiPassBrowserPasskeys ? true,
  withChiPassFDOSecrets ? true,
  withChiPassKeeShare ? true,
  withChiPassNetworking ? true,
  withChiPassSSHAgent ? true,
  withChiPassX11 ? true,
  withChiPassYubiKey ? true,

  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chipass";
  version = "2026.09.0";

  src = fetchFromCodeberg {
    owner = "ChiPass";
    repo = "ChiPass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6nA7NziEgiQolhx5cGdyZZTJ5JcKWz9WQOiJ3JiZ6UQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-old-style-cast"
      "-Wno-error"
      "-D__BIG_ENDIAN__=${if stdenv.hostPlatform.isBigEndian then "1" else "0"}"
    ];
  };

  # Upstream develops against a build of PCSC from Xcode.
  # The types are incompatible with nixpkgs pcsclite.
  # https://github.com/NixOS/nixpkgs/issues/520227
  postPatch = ''
    substituteInPlace src/keys/drivers/YubiKeyInterfacePCSC.cpp \
      --replace-fail "typedef uint32_t RETVAL;" "typedef int32_t RETVAL;"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CHIPASS_BUILD_TYPE" "Release")
    (lib.cmakeBool "CHIPASS_WITH_GUI_TESTS" true)
    (lib.cmakeBool "CHIPASS_WITH_UPDATE_CHECK" false)
    (lib.cmakeOptionType "list" "CHIPASS_DESKTOP_TYPES" (
      lib.concatStringsSep ";" ([ "Wayland" ] ++ lib.optional withChiPassX11 "X11")
    ))
    (lib.cmakeBool "CHIPASS_WITH_BROWSER" withChiPassBrowser)
    (lib.cmakeBool "CHIPASS_WITH_BROWSER_PASSKEYS" withChiPassBrowserPasskeys)
    (lib.cmakeBool "CHIPASS_WITH_KEESHARE" withChiPassKeeShare)
    (lib.cmakeBool "CHIPASS_WITH_NETWORKING" withChiPassNetworking)
    (lib.cmakeBool "CHIPASS_WITH_SSHAGENT" withChiPassSSHAgent)
    (lib.cmakeBool "CHIPASS_WITH_FDOSECRETS" withChiPassFDOSecrets)
    (lib.cmakeBool "CHIPASS_WITH_YUBIKEY" withChiPassYubiKey)
  ];

  doCheck = true;
  checkPhase =
    let
      disabledTests = lib.concatStringsSep "|" [
        # flaky
        "cli"
        "gui"
        "guipixmaps"
        "guibrowser"
        "guifdosecrets"
      ];
    in
    ''
      runHook preCheck

      export LC_ALL="en_US.UTF-8"
      export QT_QPA_PLATFORM=offscreen
      export QT_PLUGIN_PATH="${qt6Packages.qtbase}/${qt6Packages.qtbase.qtPluginPrefix}"

      make test ARGS+="-E '${disabledTests}' --output-on-failure"

      runHook postCheck
    '';

  nativeBuildInputs = [
    appstream
    asciidoctor
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
    wrapGAppsHook3
  ];

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = (
    # See https://github.com/keepassxreboot/keepassxc/blob/cd7a53abbbb81e468efb33eb56eefc12739969b8/src/browser/NativeMessageInstaller.cpp#L317
    # See https://github.com/keepassxreboot/keepassxc/blob/cd7a53abbbb81e468efb33eb56eefc12739969b8/utils/keepassxc-snap-helper.sh#L48-L58
    lib.optionalString withChiPassBrowser ''
      mkdir -p "$out/lib/mozilla/native-messaging-hosts"
      substituteAll "${./firefox-native-messaging-host.json}" "$out/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"

      mkdir -p "$out/etc/chromium/native-messaging-hosts"
      substituteAll "${./chromium-native-messaging-host.json}" "$out/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
    ''
  );

  buildInputs = [
    botan3
    libargon2
    libusb1
    libxtst
    minizip
    pcsclite
    qrencode
    qt6Packages.qt5compat
    qt6Packages.qtbase
    qt6Packages.qtsvg
    readline
    zlib
    zxcvbn-c
  ];

  passthru = {
    tests = {
      inherit (nixosTests) chipass;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A cross-platform password manager for people with extremely high demands on secure personal data management";
    longDescription = ''
      ChiPass is a modern, secure, and open-source password manager that stores and manages your most sensitive information. You can run ChiPass on Windows, macOS, and Linux systems. ChiPass is for people with extremely high demands of secure personal data management. It saves many different types of information, such as usernames, passwords, URLs, attachments, and notes in an offline, encrypted file that can be stored in any location, including private and public cloud solutions. For easy identification and management, user-defined titles and icons can be specified for entries. In addition, entries are sorted into customizable groups. An integrated search function allows you to use advanced patterns to easily find any entry in your database. A customizable, fast, and easy-to-use password generator utility allows you to create passwords with any combination of characters or easy to remember passphrases.
    '';
    homepage = "https://chipass.org";
    changelog = "https://codeberg.org/ChiPass/ChiPass/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ChiPass";
    maintainers = with lib.maintainers; [
      provokateurin
    ];
    platforms = lib.platforms.linux;
  };
})
