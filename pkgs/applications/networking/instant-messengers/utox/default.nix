{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore-dev, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "GrayHatter";
    repo = "uTox";
    rev = "v${version}";
    sha256 = "0kcz8idjsf3vc94ccxqkwnqdj5q1m8c720nsvixk25klzws2cshv";
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
