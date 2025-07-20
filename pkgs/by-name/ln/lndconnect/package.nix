{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lndconnect";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "LN-Zap";
    repo = "lndconnect";
    rev = "v${version}";
    hash = "sha256-cuZkVeFUQq7+kQo/YjXCMPANUL5QooAWgegcoWo3M0c=";
  };

  vendorHash = "sha256-iE0nht3PH2R9pTyyrySk759untC7snGt3wTXk4/pjrU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Generate QRCode to connect apps to lnd Resources";
    license = licenses.mit;
    homepage = "https://github.com/LN-Zap/lndconnect";
    platforms = platforms.linux;
    mainProgram = "lndconnect";
  };
}
