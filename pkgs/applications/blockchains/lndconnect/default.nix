{ lib, buildGoModule, fetchFromGitHub, lndconnect }:
buildGoModule rec {
  pname = "lndconnect";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "LN-Zap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cuZkVeFUQq7+kQo/YjXCMPANUL5QooAWgegcoWo3M0c=";
  };

  vendorSha256 = "sha256-iE0nht3PH2R9pTyyrySk759untC7snGt3wTXk4/pjrU=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Generate QRCode to connect apps to lnd Resources";
    license = licenses.mit;
    homepage = "https://github.com/LN-Zap/lndconnect";
    maintainers = [ maintainers.d-xo ];
    platforms = platforms.linux;
  };
}
