{ lib, buildGoModule, fetchFromGitHub, srt, ffmpeg }:

buildGoModule rec {
  pname = "srtrelay";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "voc";
    repo = "srtrelay";
    rev = "v${version}";
    sha256 = "sha256-CA+UuFOWjZjSBDWM62rda3IKO1fwC3X52mP4tg1uoO4=";
  };

  vendorHash = "sha256-xTYlfdijSo99ei+ZMX6N9gl+yw0DrPQ2wOhn6SS9S/E=";

  buildInputs = [ srt ];
  nativeCheckInputs = [ ffmpeg ];

  meta = with lib; {
    description = "Streaming-Relay for the SRT-protocol";
    homepage = "https://github.com/voc/srtrelay";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    mainProgram = "srtrelay";
  };
}
