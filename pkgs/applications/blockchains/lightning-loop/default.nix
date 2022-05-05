{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.18.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "1kg5nlvb4lb3cjn84wcylhq0l73d2n6rg4n1srnxmgs96v41y78f";
  };

  vendorSha256 = "0q3wbjfaqdj29sjlhx6fhc0p4d12aa31s6ia36jalcvf659ybb0l";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
