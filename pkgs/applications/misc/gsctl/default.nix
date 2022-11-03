{ lib, buildGoModule, fetchFromGitHub, kubectl, stdenv, updateGolangSysHook }:

buildGoModule rec {
  pname = "gsctl";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "giantswarm";
    repo = pname;
    rev = version;
    sha256 = "sha256-eemPsrSFwgUR1Jz7283jjwMkoJR38QiaiilI9G0IQuo=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-x0NRkpKLNhX4qTRfxwrjPFUyJKytuHfI1fYIcr2zEgc=";

  ldflags = [
    "-s" "-w"
    "-X github.com/giantswarm/gsctl/buildinfo.Version=${version}"
  ];

  checkInputs = [
    kubectl
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "The Giant Swarm command line interface";
    homepage = "https://github.com/giantswarm/gsctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ joesalisbury ];
  };
}
