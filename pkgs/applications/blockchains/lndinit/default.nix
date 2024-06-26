{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lndinit";
  version = "0.1.5-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7ibjDIDKP1ASvCWiF03aLCR6RXqLxmdkR5UZoU3dneA=";
  };

  vendorHash = "sha256-2AHU5/XSDJAEvAg7LmGxCmrJ/oS84fNF3mXigKFDsb4=";

  subPackages = ["."];

  meta = with lib; {
    description = "Wallet initializer utility for lnd";
    homepage = "https://github.com/lightninglabs/lndinit";
    mainProgram = "lndinit";
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero];
  };
}
