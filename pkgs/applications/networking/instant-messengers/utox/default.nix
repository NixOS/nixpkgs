{ stdenv, fetchFromGitHub, cmake, pkgconfig, libtoxcore, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  # > 0.13 should have unit tests and dbus support
  version = "0.13.0";

  src = fetchFromGitHub {
    owner  = "uTox";
    repo   = "uTox";
    rev    = "v${version}";
    sha256 = "0hdcbhmjwxhs3mr72w6x6yfnk8b0drsqyj40grg8dc0gb1x8y82j";
  };

  buildInputs = [
    libtoxcore dbus libvpx libX11 openal freetype
    libv4l libXrender fontconfig libXext libXft filter-audio
    libsodium
  ];

  nativeBuildInputs = [
    cmake git pkgconfig
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ domenkozar jgeerds ];
    platforms = platforms.all;
  };
}
