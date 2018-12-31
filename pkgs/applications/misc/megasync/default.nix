{ stdenv
, autoconf
, automake
, bash
, bashInteractive
, c-ares
, cryptopp
, curl
, doxygen
, freeimage
, fetchFromGitHub
, hicolor-icon-theme
, libmediainfo
, libraw
, libsodium
, libtool
, libuv
, libzen
, lsb-release
, makeDesktopItem
, pkgconfig
, qt5
, readline
, sqlite
, swig
, unzip
, wget }:

stdenv.mkDerivation rec {
  name = "megasync-${version}";
  version = "3.7.1.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAsync";
    rev = "v${version}_Linux";
    sha256 = "1spw2xc3m02rxljdv8z3zm8a3yyrk4a355q81zgh84jwkfds9qjy";
    fetchSubmodules = true;
  };
  
  desktopItem = makeDesktopItem {
    name = "megasync";
    exec = "megasync";
    icon = "megasync";
    comment = meta.description;
    desktopName = "MEGASync";
    genericName = "File Synchronizer";
    categories = "Network;FileTransfer;";
    startupNotify = "false";
  };

  nativeBuildInputs = [ 
    doxygen
    libsodium
    lsb-release
    qt5.qmake
    qt5.qttools
    swig
  ];
  buildInputs = [ 
    autoconf
    automake
    bash
    c-ares
    cryptopp
    curl
    freeimage
    hicolor-icon-theme
    libmediainfo
    libraw
    libtool
    libuv
    libzen
    pkgconfig
    qt5.qtbase
    qt5.qtsvg
    sqlite
    unzip
    wget 
  ];
  
  patchPhase = ''
    for file in $(find src/ -type f \( -iname configure -o -iname \*.sh  \) ); do
      substituteInPlace "$file" \
        --replace "/bin/bash" "${bashInteractive}/bin/bash"
    done
  '';
  
  configurePhase = ''
    cd src/MEGASync/mega
    ./autogen.sh
    ./configure \
        --disable-examples \
        --disable-java \
        --disable-php \
        --disable-python \
        --enable-chat \
        --with-cares \
        --with-cryptopp \
        --with-curl \
        --with-sodium \
        --with-sqlite \
        --with-zlib \
        --without-freeimage \
        --without-termcap \
        --without-ffmpeg
    cd ../..
  '';
  
  buildPhase = ''
    qmake CONFIG+="release" MEGA.pro
    lrelease MEGASync/MEGASync.pro
    make -j $NIX_BUILD_CORES
  '';
  
  installPhase = ''
    mkdir -p $out/share/icons
    install -Dm 755 MEGASync/megasync $out/bin/megasync
    cp -r ${desktopItem}/share/applications $out/share
    cp MEGASync/gui/images/uptodate.svg $out/share/icons/megasync.svg
  '';

  meta = with stdenv.lib; {
    description = "Easy automated syncing between your computers and your MEGA Cloud Drive";
    homepage    = https://mega.nz/;
    license     = licenses.free;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
