{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft }:

let

  filteraudio = stdenv.mkDerivation rec {
    name = "filter_audio-20150516";

    src = fetchFromGitHub {
      owner = "irungentoo";
      repo = "filter_audio";
      rev = "612c5a102550c614e4c8f859e753ea64c0b7250c";
      sha256 = "0bmf8dxnr4vb6y36lvlwqd5x68r4cbsd625kbw3pypm5yqp0n5na";
    };

    doCheck = false; # there are no test

    makeFlags = "PREFIX=$(out)";
  };

in stdenv.mkDerivation rec {
  name = "utox-dev-20150514";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "v0.2.s";
    sha256 = "1djvkd7y5mkcwpgimrgni6rrp8a30r2dp7ay1hmnlwa5531wxcga";
  };

  buildInputs = [ pkgconfig libtoxcore dbus libvpx libX11 openal freetype
                  libv4l libXrender fontconfig libXext libXft filteraudio ];

  doCheck = false; # there are no test

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iElectric jgeerds ];
    platforms = platforms.all;
  };
}
