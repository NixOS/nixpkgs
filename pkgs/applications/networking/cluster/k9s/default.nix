{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.24.9";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "sha256-9/P6OaSZDJ98EQ9DM4Oib0T1sC1K3WxUXh4IQU3qXbs=";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${src.rev}
  '';

  vendorSha256 = "sha256-hqmymxP4zK8GVqOxzB6vRfFyo+VIeI1suBu64/oEVig=";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 ];
  };
}
