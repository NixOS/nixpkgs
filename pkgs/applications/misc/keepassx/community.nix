{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
, qttools
, darwin

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
, wrapQtAppsHook
, yubikey-personalization
, zlib

, withKeePassBrowser ? true
, withKeePassKeeShare ? true
, withKeePassKeeShareSecure ? true
, withKeePassSSHAgent ? true
, withKeePassNetworking ? false
, withKeePassTouchID ? true
, withKeePassFDOSecrets ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "keepassxc";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = version;
    sha256 = "1xih9q1pxszalc0l29fmjxwn1vrrrrbnhc8gmi8brw5sclhbs6bh";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang [
    "-Wno-old-style-cast"
    "-Wno-error"
    "-D__BIG_ENDIAN__=${if stdenv.isBigEndian then "1" else "0"}"
  ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/local/bin" "../bin" \
      --replace "/usr/local/share/man" "../share/man"
  '';
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-rpath ${libargon2}/lib";

  patches = [
    ./darwin.patch
    # use wl-copy on Wayland - can be dropped with the next version update
    (fetchpatch {
      url = "https://github.com/keepassxreboot/keepassxc/commit/6128e5d58294f26411160f44da91087ebe7f4b07.patch";
      sha256 = "16q0h7kijqjdbskmk4ar6p3g8vcxr0bq1zrlq2bk16pk10nv4bh1";
    })
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
    export LC_ALL="en_US.UTF-8"
    export QT_QPA_PLATFORM=offscreen
    export QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}"
    # testcli and testgui are flaky - skip them both
    make test ARGS+="-E 'testcli|testgui' --output-on-failure"
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools ];

  buildInputs = [
    curl
    glibcLocales
    libXi
    libXtst
    libargon2
    libgcrypt
    libgpgerror
    libsodium
    libyubikey
    pkg-config
    qrencode
    qtbase
    qtsvg
    qtx11extras
    yubikey-personalization
    zlib
  ]
  ++ stdenv.lib.optional withKeePassKeeShareSecure quazip
  ++ stdenv.lib.optional stdenv.isDarwin qtmacextras
  ++ stdenv.lib.optional (stdenv.isDarwin && withKeePassTouchID) darwin.apple_sdk.frameworks.LocalAuthentication;

  preFixup = optionalString stdenv.isDarwin ''
    # Make it work without Qt in PATH.
    wrapQtApp $out/Applications/KeePassXC.app/Contents/MacOS/KeePassXC
  '';

  meta = {
    description = "Password manager to store your passwords safely and auto-type them into your everyday websites and applications";
    longDescription = "A community fork of KeePassX, which is itself a port of KeePass Password Safe. The goal is to extend and improve KeePassX with new features and bugfixes to provide a feature-rich, fully cross-platform and modern open-source password manager. Accessible via native cross-platform GUI, CLI, and browser integration with the KeePassXC Browser Extension (https://github.com/keepassxreboot/keepassxc-browser).";
    homepage = "https://keepassxc.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jonafato turion ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
