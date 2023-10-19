{ lib, stdenv, fetchFromGitHub, libbsd, libevent, libjpeg }:

stdenv.mkDerivation rec {
  pname = "ustreamer";
  version = "5.41";

  src = fetchFromGitHub {
    owner = "pikvm";
    repo = "ustreamer";
    rev = "v${version}";
    hash = "sha256-N70wBKiKfOhlAR9qOSkc6dlO44lJXHWiUYb8nwXMKxo=";
  };

  buildInputs = [ libbsd libevent libjpeg ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

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
