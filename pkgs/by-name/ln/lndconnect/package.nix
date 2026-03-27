{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lndconnect";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "LN-Zap";
    repo = "lndconnect";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cuZkVeFUQq7+kQo/YjXCMPANUL5QooAWgegcoWo3M0c=";
  };

  vendorHash = "sha256-iE0nht3PH2R9pTyyrySk759untC7snGt3wTXk4/pjrU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Generate QRCode to connect apps to lnd Resources";
    license = lib.licenses.mit;
    homepage = "https://github.com/LN-Zap/lndconnect";
    platforms = lib.platforms.linux;
    mainProgram = "lndconnect";
  };
})
