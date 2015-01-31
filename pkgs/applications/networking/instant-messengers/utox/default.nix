{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft }:

let

  filteraudio = stdenv.mkDerivation rec {
    name = "filter_audio-20150128";

    src = fetchFromGitHub {
      owner = "irungentoo";
      repo = "filter_audio";
      rev = "76428a6cda";
      sha256 = "0c4wp9a7dzbj9ykfkbsxrkkyy0nz7vyr5map3z7q8bmv9pjylbk9";
    };

    doCheck = false;

    makeFlags = "PREFIX=$(out)";
  };

in stdenv.mkDerivation rec {
  name = "utox-dev-20150130";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "cb7b8d09b08";
    sha256 = "0vg9h07ipwyf7p54p43z9bcymy0skiyjbm7zvyjg7r5cvqxv1vpa";
  };

  buildInputs = [ pkgconfig libtoxcore dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft filteraudio ];

  doCheck = false;
  
  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iElectric jgeerds ];
    platforms = platforms.all;
  };
}
