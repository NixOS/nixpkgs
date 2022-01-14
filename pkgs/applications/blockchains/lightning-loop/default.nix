{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.16.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "0q4lk338mr30frilgnjr43gd55z7ryj2s260437b4pnp03hmbf10";
  };

  vendorSha256 = "14862603rrss14p537j9i7iwflaaprwrnslmqm9hpb7hj52bxqfv";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
