{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.19.1-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "08jn1ybh9l9qy4j9b3psvgk7b869aaabpxh73v81980qflb9snnc";
  };

  vendorSha256 = "0wirlf43jl888bh2qxis1ihsr1g2lp2rx7p100dsb3imqbm25q3b";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
