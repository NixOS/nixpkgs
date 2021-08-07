{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.14.2-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    sha256 = "02ndln0n5k2pin9pngjcmn3wak761ml923111fyqb379zcfscrfv";
  };

  vendorSha256 = "1izdd9i4bqzmwagq0ilz2s37jajvzf1xwx3hmmbd1k3ss7mjm72r";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
