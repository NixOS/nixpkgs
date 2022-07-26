{ lib, buildGoModule, fetchFromGitHub, kubectl, stdenv }:

buildGoModule rec {
  pname = "gsctl";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "giantswarm";
    repo = pname;
    rev = version;
    sha256 = "sha256-P1hJoZ1YSZTCo5ha/Um/nYVVhbYC3dcrQGJYTSnqNu4=";
  };

  vendorSha256 = "sha256-NeRABlKUpD2ZHRid/vu34Dh9uHZ+7IXWFPX8jkexUog=";

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
