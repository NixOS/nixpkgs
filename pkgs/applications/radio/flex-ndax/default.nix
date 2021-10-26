{ lib, buildGoModule, fetchFromGitHub, pulseaudio }:

buildGoModule rec {
  pname = "flex-ndax";
  version = "0.1-20210714.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nDAX";
    rev = "v${version}";
    sha256 = "16zx6kbax59rcxyz9dhq7m8yx214knz3xayna1gzb85m6maly8v8";
  };

  buildInputs = [ pulseaudio ];

  vendorSha256 = "0qn8vg84j9kp0ycn24lkaqjnnk339j3vis4bn48ia3z5vfc22gi5";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nDAX";
    description = "FlexRadio digital audio transport (DAX) connector for PulseAudio";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
  };
}
