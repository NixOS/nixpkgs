{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore-dev, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium }:

let

  filteraudio = stdenv.mkDerivation rec {
    name = "filter_audio-20150516";

    src = fetchFromGitHub {
      owner = "irungentoo";
      repo = "filter_audio";
      rev = "612c5a102550c614e4c8f859e753ea64c0b7250c";
      sha256 = "0bmf8dxnr4vb6y36lvlwqd5x68r4cbsd625kbw3pypm5yqp0n5na";
    };

    buildInputs = [ utillinux ];

    doCheck = false;

    makeFlags = "PREFIX=$(out)";
  };

in stdenv.mkDerivation rec {
  name = "utox-dev-20151220";

  src = fetchFromGitHub {
    owner = "GrayHatter";
    repo = "uTox";
    rev = "7e2907470835746b6819d631b48dd54bc9c4de66";
    sha256 = "074wa0np8hyqwy9xqgyyds94pdfv2i1jh019m98d8apxc5vn36wk";
  };

  buildInputs = [ pkgconfig libtoxcore-dev dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft filteraudio 
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
