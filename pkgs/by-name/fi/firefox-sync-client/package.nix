{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "firefox-sync-client";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Mikescher";
    repo = "firefox-sync-client";
    rev = "v${version}";
    hash = "sha256-Ax+v4a8bVuym1bp9dliXX85PXJk2Qlik3ME+adGiL1s=";
  };

  vendorHash = "sha256-MYetPdnnvIBzrYrA+eM9z1P3+P5FumYKH+brvvlwkm4=";

  meta = {
    description = "Commandline-utility to list/view/edit/delete entries in a firefox-sync account.";
    homepage = "https://github.com/Mikescher/firefox-sync-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "ffsclient";
  };
}
