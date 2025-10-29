{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lndinit";
  version = "0.1.22-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndinit";
    rev = "v${version}";
    hash = "sha256-KXCObRUhXTEeb48hnQYrnb55g+nJomr52IIVpFDn+nY=";
  };

  vendorHash = "sha256-peyLhDEH9DKHAQfxVCvv92DErHjidA3DSjpN357Px6M=";

  subPackages = [ "." ];

  meta = {
    description = "Wallet initializer utility for lnd";
    homepage = "https://github.com/lightninglabs/lndinit";
    mainProgram = "lndinit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
