{ lib
, stdenv
, fetchFromGitHub
, cmake
, qttools

, asciidoctor
, botan2
, curl
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
, wrapGAppsHook
, wrapQtAppsHook
, zlib

, LocalAuthentication

, withKeePassBrowser ? true
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
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = version;
    sha256 = "sha256-amedKK9nplLVJTldeabN3/c+g/QesrdH+qx+rba2/4s=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang (toString [
    "-Wno-old-style-cast"
    "-Wno-error"
    "-D__BIG_ENDIAN__=${if stdenv.isBigEndian then "1" else "0"}"
  ]);

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-rpath ${libargon2}/lib";

  patches = [
    ./darwin.patch
  ];

  cmakeFlags = [
    "-DKEEPASSXC_BUILD_TYPE=Release"
    "-DWITH_GUI_TESTS=ON"
    "-DWITH_XC_UPDATECHECK=OFF"
  ]
  ++ (lib.optional (!withKeePassX11) "-DWITH_XC_X11=OFF")
  ++ (lib.optional (withKeePassFDOSecrets && stdenv.isLinux) "-DWITH_XC_FDOSECRETS=ON")
  ++ (lib.optional (withKeePassYubiKey && stdenv.isLinux) "-DWITH_XC_YUBIKEY=ON")
  ++ (lib.optional withKeePassBrowser "-DWITH_XC_BROWSER=ON")
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
    make test ARGS+="-E 'testcli|testgui${lib.optionalString stdenv.isDarwin "|testautotype|testkdbx4"}' --output-on-failure"

    runHook postCheck
  '';

  nativeBuildInputs = [ asciidoctor cmake wrapGAppsHook wrapQtAppsHook qttools pkg-config ];

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '' + lib.optionalString stdenv.isDarwin ''
    wrapQtApp "$out/Applications/KeePassXC.app/Contents/MacOS/KeePassXC"
  '';

  buildInputs = [
    curl
    botan2
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
  ++ lib.optional (stdenv.isDarwin && withKeePassTouchID) LocalAuthentication
  ++ lib.optional stdenv.isDarwin qtmacextras
  ++ lib.optional stdenv.isLinux libusb1
  ++ lib.optional withKeePassX11 qtx11extras;

  passthru.tests = nixosTests.keepassxc;

  meta = with lib; {
    description = "Offline password manager with many features.";
    longDescription = ''
      A community fork of KeePassX, which is itself a port of KeePass Password Safe.
      The goal is to extend and improve KeePassX with new features and bugfixes,
      to provide a feature-rich, fully cross-platform and modern open-source password manager.
      Accessible via native cross-platform GUI, CLI, has browser integration
      using the KeePassXC Browser Extension (https://github.com/keepassxreboot/keepassxc-browser)
    '';
    homepage = "https://keepassxc.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jonafato turion srapenne ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
