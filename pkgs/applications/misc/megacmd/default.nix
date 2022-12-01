{ lib
, stdenv
, autoreconfHook
, c-ares
, cryptopp
, curl
, fetchFromGitHub
  # build fails with latest ffmpeg, see https://github.com/meganz/MEGAcmd/issues/523.
  # to be re-enabled when patch available
  # , ffmpeg
, freeimage
, gcc-unwrapped
, libmediainfo
, libraw
, libsodium
, libuv
, libzen
, pcre-cpp
, pkg-config
, readline
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "megacmd";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAcmd";
    rev = "${version}_Linux";
    sha256 = "sha256-qOXw/KGt3DyWQGBe/pbMujQITCMItHobxuK+1r00ZIs=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    c-ares
    cryptopp
    curl
    # ffmpeg
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

  configureFlags = [
    "--disable-curl-checks"
    "--disable-examples"
    "--with-cares"
    "--with-cryptopp"
    "--with-curl"
    # "--with-ffmpeg"
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
    homepage = "https://mega.io/cmd";
    license = with licenses; [ bsd2 gpl3Only ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ lunik1 ];
  };
}
