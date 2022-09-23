{ lib, stdenv
, fetchFromGitHub
, cmake
, qttools
, darwin

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

, withKeePassBrowser ? true
, withKeePassKeeShare ? true
, withKeePassSSHAgent ? true
, withKeePassNetworking ? true
, withKeePassTouchID ? true
, withKeePassYubiKey ? true
, withKeePassFDOSecrets ? true

, nixosTests
}:

with lib;

stdenv.mkDerivation rec {
  pname = "keepassxc";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = version;
    sha256 = "sha256-BOtehDzlWhhfXj8TOFvFN4f86Hl2EC3rO4qUIl9fqq4=";
  };

  NIX_CFLAGS_COMPILE = optionalString stdenv.cc.isClang [
    "-Wno-old-style-cast"
    "-Wno-error"
    "-D__BIG_ENDIAN__=${if stdenv.isBigEndian then "1" else "0"}"
  ];

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-rpath ${libargon2}/lib";

  patches = [
    ./darwin.patch
  ];

  cmakeFlags = [
    "-DKEEPASSXC_BUILD_TYPE=Release"
    "-DWITH_GUI_TESTS=ON"
    "-DWITH_XC_UPDATECHECK=OFF"
  ]
  ++ (optional withKeePassBrowser "-DWITH_XC_BROWSER=ON")
  ++ (optional withKeePassKeeShare "-DWITH_XC_KEESHARE=ON")
  ++ (optional withKeePassNetworking "-DWITH_XC_NETWORKING=ON")
  ++ (optional (withKeePassYubiKey && stdenv.isLinux) "-DWITH_XC_YUBIKEY=ON")
  ++ (optional (withKeePassFDOSecrets && stdenv.isLinux) "-DWITH_XC_FDOSECRETS=ON")
  ++ (optional withKeePassSSHAgent "-DWITH_XC_SSHAGENT=ON");

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    export LC_ALL="en_US.UTF-8"
    export QT_QPA_PLATFORM=offscreen
    export QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}"
    # testcli and testgui are flaky - skip them both
    make test ARGS+="-E 'testcli|testgui' --output-on-failure"

    runHook postCheck
  '';

  nativeBuildInputs = [ asciidoctor cmake wrapGAppsHook wrapQtAppsHook qttools pkg-config ];

  dontWrapGApps = true;
  postFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
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
    qtx11extras
    readline
    zlib
  ]
  ++ optional stdenv.isLinux libusb1
  ++ optional stdenv.isDarwin qtmacextras
  ++ optional (stdenv.isDarwin && withKeePassTouchID) darwin.apple_sdk.frameworks.LocalAuthentication;

  passthru.tests = nixosTests.keepassxc;

  meta = {
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
    maintainers = with maintainers; [ jonafato turion ];
    platforms = platforms.linux ++ platforms.darwin;
    broken = stdenv.isDarwin;  # see to https://github.com/NixOS/nixpkgs/issues/172165
  };
}
