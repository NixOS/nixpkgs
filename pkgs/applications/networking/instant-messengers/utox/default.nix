{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore-dev, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "GrayHatter";
    repo = "uTox";
    rev = "v${version}";
    sha256 = "074wa0np8hyqwy9xqgyyds94pdfv2i1jh019m98d8apxc5vn36wk";
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
