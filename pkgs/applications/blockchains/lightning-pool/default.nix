{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-pool";
  version = "0.4.4-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${version}";
    sha256 = "1kfvn8avh2ymqp3sfwv3y6ybwbsd3hzisw7a4qkmqwymggbmky7p";
  };

  vendorSha256 = "190qy3cz18ipv8ilpqhbaaxfi9j2isxpwhagzzspa3pwcpssrv52";

  subPackages = [ "cmd/pool" "cmd/poold" ];

  meta = with lib; {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags ];
  };
}
