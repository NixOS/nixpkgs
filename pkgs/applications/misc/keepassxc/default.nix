{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, qttools

, asciidoctor
, botan3
, curl
, kio
, libXi
, libXtst
, libargon2
, libusb1
, minizip
, pcsclite
, pkg-config
, qrencode
, qtbase
, qtmacextras
, qtsvg
, qtx11extras
, readline
, wrapGAppsHook3
, wrapQtAppsHook
, zlib

, LocalAuthentication

, withKeePassBrowser ? true
, withKeePassBrowserPasskeys ? true
, withKeePassFDOSecrets ? true
, withKeePassKeeShare ? true
, withKeePassNetworking ? true
, withKeePassSSHAgent ? true
, withKeePassTouchID ? true
, withKeePassX11 ? true
, withKeePassYubiKey ? true

, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "keepassxc";
  version = "2.7.9";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = version;
    hash = "sha256-rnietdc8eDNTag0GaZ8VJb28JsKKD/qrQ0Gg6FMWpr0=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang (toString [
    "-Wno-old-style-cast"
    "-Wno-error"
    "-D__BIG_ENDIAN__=${if stdenv.hostPlatform.isBigEndian then "1" else "0"}"
  ]);

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-rpath ${libargon2}/lib";

  patches = [
    ./darwin.patch

    # https://github.com/keepassxreboot/keepassxc/issues/10391
    (fetchpatch {
      url = "https://github.com/keepassxreboot/keepassxc/commit/6a9ed210792ac60d9ed35cc702500e5ebbb95622.patch";
      hash = "sha256-CyaVMfJ0O+5vgvmwI6rYbf0G7ryKFcLv3p4b/D6Pzw8=";
    })
  ];

  cmakeFlags = [
    "-DKEEPASSXC_BUILD_TYPE=Release"
    "-DWITH_GUI_TESTS=ON"
    "-DWITH_XC_UPDATECHECK=OFF"
  ]
  ++ (lib.optional (!withKeePassX11) "-DWITH_XC_X11=OFF")
  ++ (lib.optional (withKeePassFDOSecrets && stdenv.hostPlatform.isLinux) "-DWITH_XC_FDOSECRETS=ON")
  ++ (lib.optional (withKeePassYubiKey && stdenv.hostPlatform.isLinux) "-DWITH_XC_YUBIKEY=ON")
  ++ (lib.optional withKeePassBrowser "-DWITH_XC_BROWSER=ON")
  ++ (lib.optional withKeePassBrowserPasskeys "-DWITH_XC_BROWSER_PASSKEYS=ON")
  ++ (lib.optional withKeePassKeeShare "-DWITH_XC_KEESHARE=ON")
  ++ (lib.optional withKeePassNetworking "-DWITH_XC_NETWORKING=ON")
  ++ (lib.optional withKeePassSSHAgent "-DWITH_XC_SSHAGENT=ON");

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    export LC_ALL="en_US.UTF-8"
    export QT_QPA_PLATFORM=offscreen
    export QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}"
    # testcli, testgui and testkdbx4 are flaky - skip them all
    # testautotype on darwin throws "QWidget: Cannot create a QWidget without QApplication"
    make test ARGS+="-E 'testcli|testgui${lib.optionalString stdenv.hostPlatform.isDarwin "|testautotype|testkdbx4"}' --output-on-failure"

    runHook postCheck
  '';

  nativeBuildInputs = [
    asciidoctor
    cmake
    wrapQtAppsHook
    qttools
    pkg-config
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) wrapGAppsHook3;

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapQtApp "$out/Applications/KeePassXC.app/Contents/MacOS/KeePassXC"
  '';

  # See https://github.com/keepassxreboot/keepassxc/blob/cd7a53abbbb81e468efb33eb56eefc12739969b8/src/browser/NativeMessageInstaller.cpp#L317
  postInstall = lib.optionalString withKeePassBrowser ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    substituteAll "${./firefox-native-messaging-host.json}" "$out/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
  '';

  buildInputs = [
    curl
    botan3
    kio
    libXi
    libXtst
    libargon2
    minizip
    pcsclite
    qrencode
    qtbase
    qtsvg
    readline
    zlib
  ]
  ++ lib.optional (stdenv.hostPlatform.isDarwin && withKeePassTouchID) LocalAuthentication
  ++ lib.optional stdenv.hostPlatform.isDarwin qtmacextras
  ++ lib.optional stdenv.hostPlatform.isLinux libusb1
  ++ lib.optional withKeePassX11 qtx11extras;

  passthru.tests = nixosTests.keepassxc;

  meta = with lib; {
    description = "Offline password manager with many features";
    longDescription = ''
      A community fork of KeePassX, which is itself a port of KeePass Password Safe.
      The goal is to extend and improve KeePassX with new features and bugfixes,
      to provide a feature-rich, fully cross-platform and modern open-source password manager.
      Accessible via native cross-platform GUI, CLI, has browser integration
      using the KeePassXC Browser Extension (https://github.com/keepassxreboot/keepassxc-browser)
    '';
    homepage = "https://keepassxc.org/";
    license = licenses.gpl2Plus;
    mainProgram = "keepassxc";
    maintainers = with maintainers; [ blankparticle sigmasquadron ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
