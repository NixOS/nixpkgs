{
  lib,
  buildGoModule,
  fetchFromGitHub,
  srt,
  ffmpeg,
}:

buildGoModule rec {
  pname = "srtrelay";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "voc";
    repo = "srtrelay";
    rev = "v${version}";
    sha256 = "sha256-llBPlfvW9Bvm9nL8w4BTOgccsQNAAb3omRBXBISNBcc=";
  };

  vendorHash = "sha256-z9sBrSGEHPLdC79hsNKZiI9+w8t0JrVQ8pRdBykaI5Q=";

  buildInputs = [ srt ];
  nativeCheckInputs = [ ffmpeg ];

  meta = {
    description = "Streaming-Relay for the SRT-protocol";
    homepage = "https://github.com/voc/srtrelay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fpletz ];
    mainProgram = "srtrelay";
  };
}
