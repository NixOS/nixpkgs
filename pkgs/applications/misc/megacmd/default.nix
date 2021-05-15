{ lib
, stdenv
, autoconf
, automake
, c-ares
, cryptopp
, curl
, fetchFromGitHub
, ffmpeg_3 # build fails with latest ffmpeg, see https://github.com/meganz/MEGAcmd/issues/523
, freeimage
, gcc-unwrapped
, libmediainfo
, libraw
, libsodium
, libtool
, libuv
, libzen
, pcre-cpp
, pkg-config
, readline
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "megacmd";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAcmd";
    rev = "${version}_Linux";
    sha256 = "sha256-Q1SZSDTPGgBA/W/ZVYfTQsiP41RE1LJ+esQ3PK9EjIc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    c-ares
    cryptopp
    curl
    ffmpeg_3
    freeimage
    gcc-unwrapped
    libmediainfo
    libraw
    libsodium
    libuv
    libzen
    pcre-cpp
    readline
    sqlite
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--disable-curl-checks"
    "--disable-examples"
    "--with-cares"
    "--with-cryptopp"
    "--with-curl"
    "--with-ffmpeg"
    "--with-freeimage"
    "--with-libmediainfo"
    "--with-libuv"
    "--with-libzen"
    "--with-pcre"
    "--with-readline"
    "--with-sodium"
    "--with-termcap"
  ];

  meta = with lib; {
    description = "MEGA Command Line Interactive and Scriptable Application";
    homepage = "https://mega.nz/cmd";
    license = with licenses; [ bsd2 gpl3Only ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ lunik1 ];
  };
}
