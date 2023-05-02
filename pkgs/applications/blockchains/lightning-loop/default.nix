{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.23.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "sha256-nYDu451BS5gV4pbV9Pp+S7oKsLGzgVu1a9Df7651e4c=";
  };

  vendorSha256 = "sha256-6bRg6is1g/eRCr82tHMXTWVFv2S0d2h/J3w1gpentjo=";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
