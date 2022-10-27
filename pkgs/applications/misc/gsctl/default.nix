{ lib, buildGoModule, fetchFromGitHub, kubectl, stdenv }:

buildGoModule rec {
  pname = "gsctl";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "giantswarm";
    repo = pname;
    rev = version;
    sha256 = "sha256-eemPsrSFwgUR1Jz7283jjwMkoJR38QiaiilI9G0IQuo=";
  };

  vendorSha256 = "sha256-6b4H8YAY8d/qIGnnGPYZoXne1LXHLsc0OEq0lCeqivo=";

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
