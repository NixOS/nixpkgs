{ buildGoModule
, fetchFromGitHub
, lib
}: buildGoModule rec {
  pname = "neutrond";
  version = "2.0.0";
  commit = "e605ed3db4381994ee8185ba4a0ff0877d34e67f";

  src = (fetchFromGitHub {
    owner = "neutron-org";
    repo = "neutron";
    rev = "v${version}";
    sha256 = "sha256-NuoOlrciBeL2f/A7wlQBqYlYJhSYucXRhLgxdasfyhI=";
  });

  vendorHash = "sha256-uLInKbuL886cfXCyQvIDZJHUC8AK9fR39yNBHDO+Qzc=";

  GOFLAGS = "-trimpath";
  CGO_ENABLED = 0;

  ldflags = [
    "-w -s"
    "-X github.com/cosmos/cosmos-sdk/version.Name=neutron"
    "-X github.com/cosmos/cosmos-sdk/version.AppName=neutrond"
    "-X github.com/cosmos/cosmos-sdk/version.Version=${version}"
    "-X github.com/cosmos/cosmos-sdk/version.Commit=${commit}"
    "-X github.com/cosmos/cosmos-sdk/version.BuildTags=gcc,netgo"
  ];

  subPackages = [
    "cmd/neutrond"
  ];

  meta = with lib; {
    description = "Neutron node";

    longDescription = ''
      Neutron node to interact with neutron blockchain
    '';

    homepage = "https://github.com/neutron-org/neutron";

    license = licenses.asl20; # Apache license

    maintainers = with maintainers; [
      pr0n00gler
      foxpy
    ];
  };
}
