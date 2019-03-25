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
, qrencode
, qtbase
, qtmacextras
, qtsvg
, qtx11extras
, yubikey-personalization
, zlib

, withKeePassBrowser ? true
, withKeePassSSHAgent ? true
, withKeePassNetworking ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "keepassxc-${version}";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "1k8s56003gym2dv6c54gxwzs20i7lf6w5g5qnr449jfmf6wvbivr";
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
    # FIXME: This patch no longer applies and needs to be updated or removed.
    #./darwin.patch
  ];

  cmakeFlags = [
    "-DKEEPASSXC_BUILD_TYPE=Release"
    "-DWITH_GUI_TESTS=ON"
    "-DWITH_XC_AUTOTYPE=ON"
    "-DWITH_XC_YUBIKEY=ON"
    # FIXME: WITH_XC_KEESHARE should be configurable, however the build currently
    # fails without this option. The fix for this issue will be part of the 2.4.1
    # release. See https://github.com/keepassxreboot/keepassxc/pull/2810.
    "-DWITH_XC_KEESHARE=ON"
  ]
  ++ (optional withKeePassBrowser "-DWITH_XC_BROWSER=ON")
  ++ (optional withKeePassNetworking "-DWITH_XC_NETWORKING=ON")
  ++ (optional withKeePassSSHAgent "-DWITH_XC_SSHAGENT=ON");

  doCheck = true;
  checkPhase = ''
    export LC_ALL="en_US.UTF-8" QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}" QT_QPA_PLATFORM=minimal
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
    qrencode
    qtbase
    qtsvg
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
    longDescription = "A community fork of KeePassX, which is itself a port of KeePass Password Safe. The goal is to extend and improve KeePassX with new features and bugfixes to provide a feature-rich, fully cross-platform and modern open-source password manager. Accessible via native cross-platform GUI, CLI, and browser integration with the KeePassXC Browser Extension (https://github.com/keepassxreboot/keepassxc-browser).";
    homepage = https://keepassxc.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ s1lvester jonafato ];
    platforms = with platforms; linux ++ darwin;
  };
}
