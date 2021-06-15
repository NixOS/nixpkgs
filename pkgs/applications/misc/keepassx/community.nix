{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
, qttools
, darwin

, asciidoctor
, curl
, glibcLocales
, libXi
, libXtst
, libargon2
, libgcrypt
, libgpgerror
, libsodium
, libyubikey
, pkg-config
, qrencode
, qtbase
, qtmacextras
, qtsvg
, qtx11extras
, quazip
, readline
, wrapQtAppsHook
, yubikey-personalization
, zlib

, withKeePassBrowser ? true
, withKeePassKeeShare ? true
, withKeePassKeeShareSecure ? true
, withKeePassSSHAgent ? true
, withKeePassNetworking ? true
, withKeePassTouchID ? true
, withKeePassFDOSecrets ? true

, nixosTests
}:

with lib;

stdenv.mkDerivation rec {
  pname = "keepassxc";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = version;
    sha256 = "02ajfkw818cmalvkl0kqvza85rgdgs59kw2v7b3c4v8kv00c41j3";
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
    "-DWITH_XC_AUTOTYPE=ON"
    "-DWITH_XC_UPDATECHECK=OFF"
    "-DWITH_XC_YUBIKEY=ON"
  ]
  ++ (optional withKeePassBrowser "-DWITH_XC_BROWSER=ON")
  ++ (optional withKeePassKeeShare "-DWITH_XC_KEESHARE=ON")
  ++ (optional withKeePassKeeShareSecure "-DWITH_XC_KEESHARE_SECURE=ON")
  ++ (optional withKeePassNetworking "-DWITH_XC_NETWORKING=ON")
  ++ (optional (withKeePassTouchID && stdenv.isDarwin) "-DWITH_XC_TOUCHID=ON")
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

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools pkg-config ];

  buildInputs = [
    asciidoctor
    curl
    glibcLocales
    libXi
    libXtst
    libargon2
    libgcrypt
    libgpgerror
    libsodium
    libyubikey
    qrencode
    qtbase
    qtsvg
    qtx11extras
    readline
    yubikey-personalization
    zlib
  ]
  ++ optional withKeePassKeeShareSecure quazip
  ++ optional stdenv.isDarwin qtmacextras
  ++ optional (stdenv.isDarwin && withKeePassTouchID)
    darwin.apple_sdk.frameworks.LocalAuthentication;

  preFixup = optionalString stdenv.isDarwin ''
    # Make it work without Qt in PATH.
    wrapQtApp $out/Applications/KeePassXC.app/Contents/MacOS/KeePassXC
  '';

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
  };
}
