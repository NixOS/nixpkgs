{ lib, stdenv, fetchFromGitHub, libbsd, libevent, libjpeg }:

stdenv.mkDerivation rec {
  pname = "ustreamer";
  version = "3.27";

  src = fetchFromGitHub {
    owner = "pikvm";
    repo = "ustreamer";
    rev = "v${version}";
    sha256 = "1max2171abdpix0wq7mdkji5lvkfzisj166qfgmqkkwc2nh721iw";
  };

  buildInputs = [ libbsd libevent libjpeg ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ustreamer $out/bin/
  '';

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
