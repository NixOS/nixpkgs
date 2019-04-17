{ stdenv, fetchFromGitHub, cmake, makeWrapper, qttools

, curl
, glibcLocales
, libXi
, libXtst
, libargon2
, libgcrypt
, libgpgerror
, libmicrohttpd
, libsodium
, libyubikey
, pkg-config
, qrencode
, qtbase
, qtmacextras
, qtsvg
, qtx11extras
, quazip
, yubikey-personalization
, zlib

, withKeePassBrowser ? true
, withKeePassKeeShare ? true
, withKeePassKeeShareSecure ? true
, withKeePassSSHAgent ? true
, withKeePassNetworking ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "keepassxc-${version}";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "1cbfsfdvb4qw6yb0zl6mymdbphnb7lxbfrc5a8cjmn9w8b09kv6m";
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
    ./quazip5.patch
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
  ++ (optional withKeePassSSHAgent "-DWITH_XC_SSHAGENT=ON");

  doCheck = true;
  checkPhase = ''
    export LC_ALL="en_US.UTF-8"
    export QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
    make test ARGS+="-E testgui --output-on-failure"
  '';

  nativeBuildInputs = [ cmake makeWrapper qttools ];

  buildInputs = [
    curl
    glibcLocales
    libXi
    libXtst
    libargon2
    libgcrypt
    libgpgerror
    libmicrohttpd
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
  ++ stdenv.lib.optional stdenv.isDarwin qtmacextras;

  postInstall = optionalString stdenv.isDarwin ''
    # Make it work without Qt in PATH.
    wrapProgram $out/Applications/KeePassXC.app/Contents/MacOS/KeePassXC \
      --set QT_PLUGIN_PATH ${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  meta = {
    description = "Password manager to store your passwords safely and auto-type them into your everyday websites and applications";
    longDescription = "A community fork of KeePassX, which is itself a port of KeePass Password Safe. The goal is to extend and improve KeePassX with new features and bugfixes to provide a feature-rich, fully cross-platform and modern open-source password manager. Accessible via native cross-platform GUI, CLI, and browser integration with the KeePassXC Browser Extension (https://github.com/keepassxreboot/keepassxc-browser).";
    homepage = https://keepassxc.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ s1lvester jonafato ];
    platforms = with platforms; linux ++ darwin;
  };
}
