{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-pool";
  version = "0.5.1-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${version}";
    sha256 = "147s0p4arfxl2akzm267p8zfy6hgssym5rwxv78kp8i39mfinpkn";
  };

  vendorSha256 = "0zd3bwqi0hnk0562x9hd62cwjw1xj386m83jagg41kzz0cpcr7zl";

  subPackages = [ "cmd/pool" "cmd/poold" ];

  meta = with lib; {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
