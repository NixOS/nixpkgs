{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.24.1-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    hash = "sha256-gPWiKSwXS1eSuHss+hkiqqxqonGYSGmSh3/jL+NlqEg=";
  };

  vendorHash = "sha256-6bRg6is1g/eRCr82tHMXTWVFv2S0d2h/J3w1gpentjo=";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
