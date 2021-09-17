{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "lndconnect";
  version = "0.2.0";

  goPackagePath = "github.com/LN-Zap/lndconnect";

  src = fetchFromGitHub {
    owner = "LN-Zap";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zp23vp4i4csc6x1b6z39rqcmknxd508x6clr8ckdj2fwjwkyf5a";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Generate QRCode to connect apps to lnd Resources";
    license = licenses.mit;
    homepage = "https://github.com/LN-Zap/lndconnect";
    maintainers = [ maintainers.d-xo ];
    platforms = platforms.linux;
  };
}

