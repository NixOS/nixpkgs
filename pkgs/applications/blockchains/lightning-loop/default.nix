{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.12.2-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "1yyx9j9lxdianm0mxm8zs2yn6xglc1kb7vbcalnxss8j62zn1msm";
  };

  vendorSha256 = "03z0cmn9qgcmqm8llybfn1hz1m9hx3pn18m11s3fwnay8ib00r89";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags ];
  };
}
