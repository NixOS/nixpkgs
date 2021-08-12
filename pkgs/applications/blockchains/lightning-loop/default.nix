{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.15.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "1yjc04jiam3836w7vn3b1jqj1dq1k8wwfnccir0vh29cn6v0cf63";
  };

  vendorSha256 = "0c3ly0s438sr9iql2ps4biaswphp7dfxshddyw5fcm0ajqzvhrmw";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
