{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "go-car";
  version = "2.14.3";

  src = fetchFromGitHub {
    owner = "ipld";
    repo = "go-car";
    rev = "v${version}";
    hash = "sha256-I1CVOoENQ5Qecl+8o4jbQYvXDYTPsU8QRcxCLwkJdng=";
  };

  modRoot = "cmd";
  subPackages = [ "car" ];

  vendorHash = "sha256-GO8PR20xHEybiFW/ukRZh5Rlt/Y/iJfMcnd1IVQ9Rtk=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Content addressable archive utility";
    homepage = "https://github.com/ipld/go-car/cmd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "car";
  };
}
