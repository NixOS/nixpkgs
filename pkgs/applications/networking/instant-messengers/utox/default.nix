{ stdenv, fetchFromGitHub, cmake, pkgconfig, libtoxcore, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  # >= 0.14 should have unit tests and dbus support
  version = "0.13.1";

  src = fetchFromGitHub {
    owner  = "uTox";
    repo   = "uTox";
    rev    = "v${version}";
    sha256 = "07aa92isknxf7531jr9kgk89wl5rvv34jrvir043fs9xvim5zq99";
  };

  buildInputs = [
    libtoxcore dbus libvpx libX11 openal freetype
    libv4l libXrender fontconfig libXext libXft filter-audio
    libsodium
  ];

  nativeBuildInputs = [
    cmake git pkgconfig
  ];

  cmakeFlags = [
    "-DENABLE_UPDATER=OFF"
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    homepage = https://github.com/uTox/uTox;
    license = licenses.gpl3;
    maintainers = with maintainers; [ domenkozar jgeerds ];
    platforms = platforms.all;
  };
}
