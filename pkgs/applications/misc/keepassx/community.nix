{ stdenv, fetchFromGitHub, cmake, makeWrapper, qttools
, libgcrypt, zlib, libmicrohttpd, libXtst, qtbase, libgpgerror, glibcLocales, libyubikey, yubikey-personalization, libXi, qtx11extras
, withKeePassHTTP ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "keepassxc-${version}";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "0q913v2ka6p7jr7c4w9fq8aqh5v6nxqgcv9h7zllk5p0amsf8d80";
  };

  patches = [ ./cmake.patch ./darwin.patch ];

  cmakeFlags = [
    "-DWITH_GUI_TESTS=ON"
    "-DWITH_XC_AUTOTYPE=ON"
    "-DWITH_XC_YUBIKEY=ON"
  ] ++ (optional withKeePassHTTP "-DWITH_XC_HTTP=ON");

  doCheck = true;
  checkPhase = ''
    export LC_ALL="en_US.UTF-8"
    make test ARGS+="-E testgui --output-on-failure"
  '';

  nativeBuildInputs = [ cmake makeWrapper qttools ];

  buildInputs = [ libgcrypt zlib qtbase libXtst libmicrohttpd libgpgerror glibcLocales libyubikey yubikey-personalization libXi qtx11extras ];

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
