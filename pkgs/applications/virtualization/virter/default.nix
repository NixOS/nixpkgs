{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "virter";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "LINBIT";
    repo = "virter";
    rev = "v${version}";
    hash = "sha256-Ae7lQveslZ4XqMmnC5mkZOk/8WSLXpmeRjkYUkIaasg=";
  };

  vendorHash = "sha256-7aWrY9EMTaJrNd0MTFIMfyUJ67I0LtndqNH0INo/OfA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/LINBIT/virter/cmd.version=${version}"
    "-X github.com/LINBIT/virter/cmd.builddate=builtByNix"
    "-X github.com/LINBIT/virter/cmd.githash=builtByNix"
  ];

  # requires network access
  doCheck = false;

  meta = {
    description = "A command line tool for simple creation and cloning of virtual machines based on libvirt";
    homepage = "https://github.com/LINBIT/virter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "virter";
  };
}
