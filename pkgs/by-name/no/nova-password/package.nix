{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "nova-password";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = "nova-password";
    rev = "refs/tags/v${version}";
    hash = "sha256-+qFbBjjbp1Nazpo21oOytvEPzn6Nmc4Cr8du045Ab/E=";
  };

  vendorHash = "sha256-tRBWniPM/IPR/JKi7R46tnx9rgyCb5hOkOR1oy7iVcc=";

  meta = {
    description = "Decrypt the admin password generated for the VM in OpenStack";
    homepage = "https://github.com/sapcc/nova-password";
    license = lib.licenses.asl20;
    mainProgram = "nova-password";
    maintainers = with lib.maintainers; [ vinetos ];
    platforms = lib.platforms.all;
  };
}
