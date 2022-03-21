{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-pool";
  version = "0.5.3-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${version}";
    sha256 = "1nc3hksk9qcxrsyqpz9vcfc8x093rc8yx8ppfk177j9fhdnn8bk7";
  };

  vendorSha256 = "09yxaa74814l1rp0arqhqpplr2j0p8dj81zqcbxlwp5ckjv9r2za";

  subPackages = [ "cmd/pool" "cmd/poold" ];

  meta = with lib; {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
