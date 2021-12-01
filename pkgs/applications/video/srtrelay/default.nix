{ lib, buildGoModule, fetchFromGitHub, srt, ffmpeg }:

buildGoModule rec {
  pname = "srtrelay-unstable";
  version = "2021-07-28";

  src = fetchFromGitHub {
    owner = "voc";
    repo = "srtrelay";
    rev = "c4f02ff2e9637b01a0679b29e5a76f4521eeeef3";
    sha256 = "06zbl97bjjyv51zp27qk37ffpbh1ylm9bsr0s5qlyd73pyavcj1g";
  };

  vendorSha256 = "1pdpb0my7gdvjjkka6jhj19b9nx575k6117hg536b106ij2n4zd2";

  buildInputs = [ srt ];
  checkInputs = [ ffmpeg ];

  meta = with lib; {
    description = "Streaming-Relay for the SRT-protocol";
    homepage = "https://github.com/voc/srtrelay";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
