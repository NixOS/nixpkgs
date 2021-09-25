{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0vsOZbSQtoWvU81wnT7QWNhvIclwGAu441lTOuZnXho=";
  };

  vendorSha256 = "sha256-3OTkigryWsyCytyNMyumJJtc/BwtdryvDQRan2dzqfg=";

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
