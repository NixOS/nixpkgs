{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "kubemqctl";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z6Xvxw2mPiwgRQJhwgDt3YmmVu8aLVwP8ih2aOtGS3o=";
  };

  vendorSha256 = "sha256-vRI/KTgxvNiVmIWf3XgA0T7IW+IRb5UAYCGtAUEVt+w=";

  patches = [
    # Add missing go.sum
    (fetchpatch {
      url = "https://github.com/kubemq-io/kubemqctl/pull/22/commits/18db7fc8aa8dfdfdea4077cf471d8469740c63ca.patch";
      sha256 = "sha256-nLme6uFqGdkp/w/s8EIo/vekDbZBzhgbdzNRn/wg5yA=";
    })
  ];

  ldflags = [ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false; # TODO tests are failing

  meta = with lib; {
    homepage = "https://github.com/kubemq-io/kubemqctl";
    description = "Kubemqctl is a command line interface (CLI) for Kubemq Kubernetes Message Broker.";
    license = licenses.asl20;
    maintainers = with maintainers; [ brianmcgee ];
  };
}
