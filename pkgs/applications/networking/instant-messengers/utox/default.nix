{ stdenv, fetchFromGitHub, cmake, pkgconfig, libtoxcore, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner  = "uTox";
    repo   = "uTox";
    rev    = "v${version}";
    sha256 = "1y26dpx0qc01mhv2f325ymyc3r7ihayrr10rp25p1bs24010azwn";
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

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ domenkozar jgeerds ];
    platforms = platforms.all;
  };
}
