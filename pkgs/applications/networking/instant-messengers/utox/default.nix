{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore-dev, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "GrayHatter";
    repo = "uTox";
    rev = "v${version}";
    sha256 = "12l2821m4r8p3vmsqhqhfj60yhkl4w4xfy73cvy73qqw6xf2yam1";
  };

  buildInputs = [ pkgconfig libtoxcore-dev dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft filter-audio
                  git libsodium ];

  doCheck = false;

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ domenkozar jgeerds ];
    platforms = platforms.all;
  };
}
