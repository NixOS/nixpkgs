{ lib
, stdenv
, autoconf
, automake
, bash
, bashInteractive
, c-ares
, cryptopp
, curl
, doxygen
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
, sqlite
, swig
, unzip
, wget
, enableFFmpeg   ? true, ffmpeg  ? ffmpeg
}:

assert enableFFmpeg   -> ffmpeg != null;

stdenv.mkDerivation rec {
  name = "megasync-${version}";
  version = "4.1.1.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAsync";
    rev = "v${version}_Linux";
    sha256 = "0lc228q3s9xp78dxjn22g6anqlsy1hi7a6yfs4q3l6gyfc3qcxl2";
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
    autoconf
    automake
    doxygen
    lsb-release
    pkgconfig
    qt5.qmake
    qt5.qttools
    swig
  ];
  buildInputs = [
    c-ares
    cryptopp
    curl
    #freeimage    # unreferenced
    hicolor-icon-theme
    libmediainfo
    libraw
    libsodium
    libtool
    libuv
    libzen
    qt5.qtbase
    qt5.qtsvg
    sqlite
    unzip
    wget
  ] ++ stdenv.lib.optionals enableFFmpeg   [ ffmpeg ];

  patchPhase = ''
    for file in $(find src/ -type f \( -iname configure -o -iname \*.sh  \) ); do
      substituteInPlace "$file" \
        --replace "/bin/bash" "${bashInteractive}/bin/bash"
    done
  '';

  preConfigure = ''
    cd src/MEGASync/mega
    ./autogen.sh
  '';

  configureScript = "./configure";

  configureFlags = [
          "--disable-examples"
          "--disable-java"
          "--disable-php"
          "--enable-chat"
          "--with-cares"
          "--with-cryptopp"
          "--with-curl"
          "--without-freeimage"  # unreferenced even when found
          "--without-readline"
          "--without-termcap"
          "--with-sodium"
          "--with-sqlite"
          "--with-zlib"
    ] ++ stdenv.lib.optionals enableFFmpeg ["--with-ffmpeg"];

  # TODO: unless overriden, qmake is called instead ??
  configurePhase = ''
    runHook preConfigure
    ./configure ${toString configureFlags}
    runHook postConfigure
  '';

  postConfigure = "cd ../..";

  preBuild = ''
    qmake CONFIG+="release" MEGA.pro
    lrelease MEGASync/MEGASync.pro
  '';

  # TODO: install bindings
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
    maintainers = [ maintainers.michojel ];
  };
}
