{
  lib,
  buildGoModule,
  fetchFromGitHub,
  srt,
  ffmpeg,
}:

buildGoModule rec {
  pname = "srtrelay";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "voc";
    repo = "srtrelay";
    rev = "v${version}";
    sha256 = "sha256-idWAJD6dvvM5OHox5+MI8q3knyl2ANqBiXfQ0VlF67Q=";
  };

  vendorHash = "sha256-a4Efva0nWeyHjftuky76znbHOrZYXaIVENKbHK9xnb8=";

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
