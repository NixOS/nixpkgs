{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.14.1-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "0fnbf0cryrw9yk3z1g7innv1rxxk7h2lhfakdj994l5a0pgzghmy";
  };

  vendorSha256 = "1i7mmf4ab4a6h08df6zlyjdnmvn44i2y3fc05hq6g1ln1bzdrz40";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
