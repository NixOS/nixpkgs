{ stdenv, fetchFromGitHub, cmake, makeWrapper, qttools

, curl
, libargon2
, libgcrypt
, libsodium
, zlib
, libmicrohttpd
, libXtst
, qtbase
, libgpgerror
, glibcLocales
, libyubikey
, yubikey-personalization
, libXi
, qtx11extras
, qtmacextras

, withKeePassBrowser ? true
, withKeePassSSHAgent ? true
, withKeePassHTTP ? false
, withKeePassNetworking ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "keepassxc-${version}";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "1xlg8zb22c2f1pi2has4f4qwggd0m2z254f0d6jrgz368x4g3p87";
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
  patches = [ ./darwin.patch ];

  cmakeFlags = [
    "-DKEEPASSXC_BUILD_TYPE=Release"
    "-DWITH_GUI_TESTS=ON"
    "-DWITH_XC_AUTOTYPE=ON"
    "-DWITH_XC_YUBIKEY=ON"
  ]
  ++ (optional withKeePassBrowser "-DWITH_XC_BROWSER=ON")
  ++ (optional withKeePassHTTP "-DWITH_XC_HTTP=ON")
  ++ (optional withKeePassNetworking "-DWITH_XC_NETWORKING=ON")
  ++ (optional withKeePassSSHAgent "-DWITH_XC_SSHAGENT=ON");

  doCheck = true;
  checkPhase = ''
    export LC_ALL="en_US.UTF-8"
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
    qtbase
    qtx11extras
    yubikey-personalization
    zlib
  ] ++ stdenv.lib.optional stdenv.isDarwin qtmacextras;

  postInstall = optionalString stdenv.isDarwin ''
    # Make it work without Qt in PATH.
    wrapProgram $out/Applications/KeePassXC.app/Contents/MacOS/KeePassXC \
      --set QT_PLUGIN_PATH ${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  meta = {
    description = "Password manager to store your passwords safely and auto-type them into your everyday websites and applications";
    longDescription = "A community fork of KeePassX, which is itself a port of KeePass Password Safe. The goal is to extend and improve KeePassX with new features and bugfixes to provide a feature-rich, fully cross-platform and modern open-source password manager. Accessible via native cross-platform GUI and via CLI. Includes optional http-interface to allow browser-integration with plugins like PassIFox (https://github.com/pfn/passifox).";
    homepage = https://keepassxc.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ s1lvester jonafato ];
    platforms = with platforms; linux ++ darwin;
  };
}
