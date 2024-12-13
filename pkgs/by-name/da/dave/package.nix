{
  lib,
  buildGoModule,
  fetchFromGitHub,
  mage,
}:

buildGoModule rec {
  pname = "dave";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "micromata";
    repo = "dave";
    rev = "v${version}";
    hash = "sha256-wvsW4EwMWAgEV+LPeMhHL4AsuyS5TDMmpD9D4F1nVM4=";
  };

  deleteVendor = true;
  vendorHash = "sha256-iyq2DGdbdfJIRNkGAIKTk1LLDydpVX3juQFaG6H5vJQ=";

  patches = [
    # Add Go Modules support:
    # - Based on https://github.com/micromata/dave/commit/46ae146dd2e95d57be35fa01885ea2c55fd8c279.
    # - Bump golang.org/x/sys for Darwin.
    ./go-modules.patch
  ];

  subPackages = [
    "cmd/dave"
    "cmd/davecli"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  meta = with lib; {
    homepage = "https://github.com/micromata/dave";
    description = "Totally simple and very easy to configure stand alone webdav server";
    license = licenses.asl20;
    maintainers = with maintainers; [ lunik1 ];
  };
}
