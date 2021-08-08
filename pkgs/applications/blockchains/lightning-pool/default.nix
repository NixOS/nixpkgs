{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-pool";
  version = "0.5.0-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${version}";
    sha256 = "0i8qkxnrx3a89aw3v0mx7przlldl8kc0ng6g1m435366y6nzdarb";
  };

  vendorSha256 = "04v2788w8l734n5xz6fwjbwkqlbk8q77nwncjpn7890mw75yd3rn";

  subPackages = [ "cmd/pool" "cmd/poold" ];

  meta = with lib; {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
