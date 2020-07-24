{ stdenv
, autoconf
, automake
, c-ares
, cryptopp
, curl
, fetchFromGitHub
, ffmpeg_3
, freeimage
, gcc-unwrapped
, libmediainfo
, libraw
, libsodium
, libtool
, libuv
, libzen
, pcre-cpp
, pkgconfig
, readline
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "megacmd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAcmd";
    rev = "${version}_Linux";
    sha256 = "0czyhsms0a0237d6h9b21n9p4nm4zkjanhhbvw26k6266g6c1nyr";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkgconfig
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
    libtool
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

  meta = with stdenv.lib; {
    description = "MEGA Command Line Interactive and Scriptable Application";
    homepage    = "https://mega.nz/";
    license     = licenses.unfree;
    platforms   = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.wedens ];
  };
}
