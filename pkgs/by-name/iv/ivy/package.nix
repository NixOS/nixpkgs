{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ivy";
  version = "0.3.4";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robpike";
    repo = "ivy";
    hash = "sha256-/Q929ZXv3F6MZ+FdWKfbThNDT3JpvQw7WLGnbmitdOg=";
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
