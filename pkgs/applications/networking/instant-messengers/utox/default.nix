{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore-dev, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "GrayHatter";
    repo = "uTox";
    rev = "v${version}";
    sha256 = "0ahwdwqhi1gmvw80jihc1ba4cqqnx8ifjnzazxidfdky4ikzccmn";
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
