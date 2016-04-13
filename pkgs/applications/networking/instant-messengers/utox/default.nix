{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore-dev, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "GrayHatter";
    repo = "uTox";
    rev = "v${version}";
    sha256 = "1md8fw6zqd3giskd89i56dgrsl83vn27xwr8k22263wkj1fxxw4c";
  };

  buildInputs = [ pkgconfig libtoxcore-dev dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft filter-audio
                  git libsodium ];

  doCheck = false;

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iElectric jgeerds ];
    platforms = platforms.all;
  };
}
