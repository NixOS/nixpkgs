{
  augeas,
  buildGoModule,
  fetchFromGitHub,
  gotools,
  lib,
  libvirt,
  libxml2,
  nex,
  pkg-config,
  ragel,
}:
buildGoModule rec {
  pname = "mgmt";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "purpleidea";
    repo = "mgmt";
    tag = version;
    hash = "sha256-Qi9KkWzFOqmUp5CSHxzQabQ8bVnBbxxKS/W6aLBTv6k=";
  };

  buildInputs = [
    augeas
    libvirt
    libxml2
  ];

  nativeBuildInputs = [
    gotools
    nex
    pkg-config
    ragel
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.program=mgmt"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  vendorHash = "sha256-XZTDqN5nQqze41Y/jOhT3mFHXeR2oPjXpz7CJuPOi8k=";

  meta = with lib; {
    description = "Next generation distributed, event-driven, parallel config management";
    homepage = "https://mgmtconfig.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "mgmt";
  };
}
