{ stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libgcrypt,
  zlib,
  libmicrohttpd,
  libXtst,
  qtbase,
  qttools,
  libgpgerror,
  glibcLocales,
  libyubikey,
  yubikey-personalization,
  libXi,
  qtx11extras,
  clang,
  withKeePassHTTP ? true
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

  cmakeFlags = [
    "-DWITH_GUI_TESTS=ON"
    "-DWITH_XC_AUTOTYPE=ON"
    "-DWITH_XC_YUBIKEY=ON"
  ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_ARCHITECTURES=x86_64"
    "-DCMAKE_CXX_STANDARD_COMPUTED_DEFAULT=14"
    # We need to trick cmake into thinking the CXX_Compiler is AppleClang 6+.
    # If cmake thinks it's Clang 4.0.1, it'll throw the following error:
    # No known features for CXX compiler "Clang" version 4.0.1.
    "-DCMAKE_CXX_COMPILER_ID='AppleClang'"
    "-DCMAKE_CXX_COMPILER_VERSION='9.0.0.9000039'"
    "-DCMAKE_PREFIX_PATH=${qtbase.dev}/lib/cmake"
    "-DQT_BINARY_DIR=${qttools.bin}/bin"
    "-DWITH_APP_BUNDLE=OFF"
  ]
  ++ (optional withKeePassHTTP "-DWITH_XC_HTTP=ON");

  doCheck = true;
  checkPhase = ''
    export LC_ALL="en_US.UTF-8"
    make test ARGS+="-E testgui --output-on-failure"
  '';

  buildInputs = [
    cmake
    libgcrypt
    zlib
    qtbase
    qttools
    libXtst
    libmicrohttpd
    libgpgerror
    glibcLocales
    libyubikey
    yubikey-personalization
    libXi
    qtx11extras
  ]
  ++ stdenv.lib.optionals stdenv.isDarwin [ clang ];

  meta = {
    description = "Password manager to store your passwords safely and auto-type them into your everyday websites and applications";
    longDescription = "A community fork of KeePassX, which is itself a port of KeePass Password Safe. The goal is to extend and improve KeePassX with new features and bugfixes to provide a feature-rich, fully cross-platform and modern open-source password manager. Accessible via native cross-platform GUI and via CLI. Includes optional http-interface to allow browser-integration with plugins like PassIFox (https://github.com/pfn/passifox).";
    homepage = https://keepassxc.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ s1lvester jonafato ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
