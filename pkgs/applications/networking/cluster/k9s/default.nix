{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.24.15";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "sha256-ws5JC2/WkgwxKwYtP9xtFELRhztzL6tNSvopyeC6H0Q=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/derailed/k9s/cmd.version=${version}"
    "-X github.com/derailed/k9s/cmd.commit=${src.rev}"
  ];

  vendorSha256 = "sha256-T9khJeg5XPhVyUiu4gEEHZR6RgJF4P8LYFycqJglms8=";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 ];
  };
}
