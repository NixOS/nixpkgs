{ stdenv, autoconf, automake, c-ares, cryptopp, curl, doxygen, fetchFromGitHub
, fetchpatch, ffmpeg, libmediainfo, libraw, libsodium, libtool, libuv, libzen
, lsb-release, mkDerivation, pkgconfig, qtbase, qttools, sqlite, swig, unzip
, wget }:

mkDerivation rec {
  pname = "megasync";
  version = "4.2.5.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAsync";
    rev = "v${version}_Linux";
    sha256 = "1zw7x8gpvzhnzyirs5ishjl5idzyyin4wdxa67d6gzfgvqi33n7w";
    fetchSubmodules = true;
  };

  nativeBuildInputs =
    [ autoconf automake doxygen lsb-release pkgconfig qttools swig ];
  buildInputs = [
    c-ares
    cryptopp
    curl
    ffmpeg
    libmediainfo
    libraw
    libsodium
    libtool
    libuv
    libzen
    qtbase
    sqlite
    unzip
    wget
  ];

  patches = [
    # Distro and version targets attempt to use lsb_release which is broken
    # (see issue: https://github.com/NixOS/nixpkgs/issues/22729)
    ./noinstall-distro-version.patch
    # megasync target is not part of the install rule thanks to a commented block
    ./install-megasync.patch

    # Fix build errror also described upstream:
    # https://github.com/meganz/MEGAsync/pull/313
    (fetchpatch {
      url = "https://github.com/meganz/MEGAsync/pull/313.patch";
      sha256 = "1ld00cnh9afxibvkzkqi8gz59xlzidw2dy4yqngwwdqy76sfsn3w";
    })
  ];

  postPatch = ''
    for file in $(find src/ -type f \( -iname configure -o -iname \*.sh  \) ); do
      substituteInPlace "$file" --replace "/bin/bash" "${stdenv.shell}"
    done
  '';

  dontUseQmakeConfigure = true;
  enableParallelBuilding = true;

  preConfigure = ''
    cd src/MEGASync/mega
    ./autogen.sh
  '';

  configureFlags = [
    "--disable-examples"
    "--disable-java"
    "--disable-php"
    "--enable-chat"
    "--with-cares"
    "--with-cryptopp"
    "--with-curl"
    "--with-ffmpeg"
    "--without-freeimage" # unreferenced even when found
    "--without-readline"
    "--without-termcap"
    "--with-sodium"
    "--with-sqlite"
    "--with-zlib"
  ];

  postConfigure = ''
    cd ../..
  '';

  preBuild = ''
    qmake CONFIG+="release" MEGA.pro
    pushd MEGASync
      lrelease MEGASync.pro
      DESKTOP_DESTDIR="$out" qmake PREFIX="$out" -o Makefile MEGASync.pro CONFIG+=release
    popd
  '';

  meta = with stdenv.lib; {
    description =
      "Easy automated syncing between your computers and your MEGA Cloud Drive";
    homepage = "https://mega.nz/";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.michojel ];
  };
}
