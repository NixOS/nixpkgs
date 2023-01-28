{ lib, vscode-utils, terraform-ls }:
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.19.0";
    sha256 = "sha256-k/fcEJuELz0xkwivSrP6Nxtz861BLq1wR2ZDMXVrvkY=";
  };

  patches = [ ./fix-terraform-ls.patch ];

  postPatch = ''
    substituteInPlace out/serverPath.js --replace TERRAFORM-LS-PATH ${terraform-ls}/bin/terraform-ls
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
