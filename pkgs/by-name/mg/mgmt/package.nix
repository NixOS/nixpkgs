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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "purpleidea";
    repo = "mgmt";
    tag = version;
    hash = "sha256-FPvxvPAOKl/XOTC4+6VgOy8O3hJyWQY8+CiCY25PlW4=";
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

  vendorHash = "sha256-huKMGmeW4Ee50oVCz9B1XrOdbRbGUI8bF3H1srqyG0A=";

  meta = with lib; {
    description = "Next generation distributed, event-driven, parallel config management";
    homepage = "https://mgmtconfig.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "mgmt";
  };
}
