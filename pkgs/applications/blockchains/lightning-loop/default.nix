{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.20.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "1nx7i4i96982z756r79655hjf0yyz5l9lqjkvyvb62pbzqgm6my8";
  };

  vendorSha256 = "0gp89fw6g8mz2ifn9wcbj84dgm736cspfxj2x34b524l2d8wz3lb";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
