{ lib, stdenv, fetchFromGitHub, libbsd, libevent, libjpeg }:

stdenv.mkDerivation rec {
  pname = "ustreamer";
<<<<<<< HEAD
  version = "5.41";
=======
  version = "5.37";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pikvm";
    repo = "ustreamer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-N70wBKiKfOhlAR9qOSkc6dlO44lJXHWiUYb8nwXMKxo=";
=======
    sha256 = "sha256-Ervzk5TNYvo7nHyt0cBN8BMjgJKu2sqeXCltero3AnE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ libbsd libevent libjpeg ];

<<<<<<< HEAD
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

=======
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ustreamer $out/bin/
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/pikvm/ustreamer";
    description = "Lightweight and fast MJPG-HTTP streamer";
    longDescription = ''
      µStreamer is a lightweight and very quick server to stream MJPG video from
      any V4L2 device to the net. All new browsers have native support of this
      video format, as well as most video players such as mplayer, VLC etc.
      µStreamer is a part of the Pi-KVM project designed to stream VGA and HDMI
      screencast hardware data with the highest resolution and FPS possible.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tfc ];
    platforms = platforms.linux;
  };
}
