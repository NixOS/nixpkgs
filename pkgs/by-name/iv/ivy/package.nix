{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ivy";
  version = "0.4.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robpike";
    repo = "ivy";
    hash = "sha256-O+CQUS2EYPnRf8AbL2arhF7m5vhPUnDFXJsYst9/Eqg=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/robpike/ivy";
    description = "APL-like calculator";
    mainProgram = "ivy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smasher164 ];
  };
}
